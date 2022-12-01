use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    let mut lines = stdin.lock().lines();

    let mut max_cal1 = 0;
    let mut max_cal2 = 0;
    let mut max_cal3 = 0;
    let mut cal = 0;

    while let Some(line) = lines.next() {
        let length: i32 = line.unwrap().trim().parse().unwrap();

        for _ in 0..length {
            let line = lines
                .next()
                .expect("there was no next line")
                .expect("the line could not be read");

            if line == "" {
                if cal > max_cal1 {
                    max_cal3 = max_cal2;
                    max_cal2 = max_cal1;
                    max_cal1 = cal;
                } else if cal > max_cal2 {
                    max_cal3 = max_cal2;
                    max_cal2 = cal;
                } else if cal > max_cal3 {
                    max_cal3 = cal;
                }
                cal = 0
            } else {
                cal += line.parse::<i32>().unwrap()
            }
            dbg!("{}", max_cal1 + max_cal2 + max_cal3);
        }
    }
}
