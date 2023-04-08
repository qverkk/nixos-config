use std::env;
use std::process::Command;
use std::thread;
use std::time::Duration;
use regex::Regex;
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize)]
struct Brightness {
    percentage: String,
}

fn main() {
    let args: Vec<String> = env::args().collect();

    match args.get(1).map(String::as_str) {
        Some("info") => {
            get_brightness_info();
        }
        Some("lower") => {
            lower_brightness();
        }
        Some("raise") => {
            raise_brightness();
        }
        Some("scan") => {
            loop {
                get_brightness_info();
                thread::sleep(Duration::from_secs(10));
            }
        }
        _ => {
            println!("Usage: brightness [info|lower|raise]");
        }
    }
}

fn get_brightness_info() {
    let output = Command::new("brightnessctl")
        .arg("i")
        .arg("--device")
        .arg("intel_backlight")
        .output()
        .expect("Failed to get brightness");

    let info_str = String::from_utf8_lossy(&output.stdout);
    let re = Regex::new(r"(\d+%)\)").unwrap();
    let percentage_str = re.captures(&info_str).unwrap().get(1).unwrap().as_str().to_string();

    let brightness_json = serde_json::to_string(&Brightness { percentage: percentage_str }).unwrap();

    println!("{}", brightness_json);
}

fn lower_brightness() {
    let _output = Command::new("brightnessctl")
        .arg("s")
        .arg("5%-")
        .arg("--device")
        .arg("intel_backlight")
        .output()
        .expect("Failed to lower brightness");
}

fn raise_brightness() {
    let _output = Command::new("brightnessctl")
        .arg("s")
        .arg("5%+")
        .arg("--device")
        .arg("intel_backlight")
        .output()
        .expect("Failed to raise brightness");
}
