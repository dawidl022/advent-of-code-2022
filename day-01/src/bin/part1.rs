use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let mut lines = stdin.lock().lines();

    let mut max_cal = 0;
    let mut cal = 0;

    while let Some(line) = lines.next() {
        match line {
            Ok(line) => {
                if line == "" {
                    if cal > max_cal {
                        max_cal = cal;
                    }
                    cal = 0
                } else {
                    cal += line.parse::<i32>().unwrap()
                }
            }
            Err(_) => {
                break;
            }
        }
    }
    println!("{max_cal}")
}
