use serde::{Deserialize, Serialize};
use std::process::Command;
use std::thread;
use std::time::Duration;

#[derive(Serialize, Deserialize)]
struct BatteryInfo {
    available: bool,
    percentage: u32,
    capacity: f32,
    time_to_full: Option<String>,
    time_to_empty: Option<String>,
}

fn main() {
    let mut battery_found = false;

    loop {
        // Get battery info
        let output = match Command::new("upower")
            .arg("-i")
            .arg("/org/freedesktop/UPower/devices/battery_BAT0")
            .output()
            .map_err(|e| format!("Failed to execute upower command: {}", e))
        {
            Ok(res) => res,
            Err(e) => {
                if battery_found {
                    thread::sleep(Duration::from_secs(60));
                    continue;
                }
                panic!("{:?}", e);
            }
        };

        battery_found = true;

        let output_str = String::from_utf8_lossy(&output.stdout);

        let battery_percent = output_str
            .lines()
            .find(|line| line.contains("percentage"))
            .unwrap()
            .trim()
            .split(": ")
            .last()
            .unwrap()
            .trim_end_matches("%")
            .trim()
            .parse::<u32>()
            .unwrap();

        let battery_capacity = output_str
            .lines()
            .find(|line| line.contains("capacity"))
            .unwrap()
            .split(": ")
            .last()
            .unwrap()
            .trim_end_matches("%")
            .trim()
            .replace(',', ".")
            .parse::<f32>()
            .unwrap();

        let time_to_full = output_str
            .lines()
            .find(|line| line.contains("time to full"))
            .map(|line| {
                let time = line
                    .split(": ")
                    .last()
                    .unwrap()
                    .trim_end_matches(" hours")
                    .trim_end_matches(" days")
                    .trim_end_matches(" minutes")
                    .trim()
                    .replace(',', ".");

                let time_in_hours = match time.parse::<f32>() {
                    Ok(v) => v,
                    Err(_) => panic!("Failed to parse time to float"),
                };

                let time_unit = if line.contains(" days") {
                    "days"
                } else if line.contains(" hours") {
                    "hours"
                } else {
                    "minutes"
                };

                let time_in_hours = match time_unit {
                    "days" => time_in_hours * 24.0,
                    "minutes" => time_in_hours / 60.0,
                    _ => time_in_hours,
                };

                let hours = time_in_hours.floor() as u32;
                let minutes = ((time_in_hours - hours as f32) * 60.0).round() as u32;
                format!("{:02}:{:02}", hours, minutes)
            });

        let time_to_empty = output_str
            .lines()
            .find(|line| line.contains("time to empty"))
            .map(|line| {
                let time = line
                    .split(": ")
                    .last()
                    .unwrap()
                    .trim_end_matches(" hours")
                    .trim_end_matches(" days")
                    .trim_end_matches(" minutes")
                    .trim()
                    .replace(',', ".");

                let time_in_hours = match time.parse::<f32>() {
                    Ok(v) => v,
                    Err(_) => panic!("Failed to parse time to float"),
                };

                let time_unit = if line.contains(" days") {
                    "days"
                } else if line.contains(" hours") {
                    "hours"
                } else {
                    "minutes"
                };

                let time_in_hours = match time_unit {
                    "days" => time_in_hours * 24.0,
                    "minutes" => time_in_hours / 60.0,
                    _ => time_in_hours,
                };

                let hours = time_in_hours.floor() as u32;
                let minutes = ((time_in_hours - hours as f32) * 60.0).round() as u32;
                format!("{:02}:{:02}", hours, minutes)
            });

        // Create BatteryInfo struct and serialize to JSON
        let battery_info = BatteryInfo {
            available: true,
            percentage: battery_percent,
            capacity: battery_capacity,
            time_to_full,
            time_to_empty,
        };

        let battery_info_json = serde_json::to_string(&battery_info).unwrap();
        println!("{}", battery_info_json);

        // Sleep for 60 seconds
        thread::sleep(Duration::from_secs(60));
    }
}
