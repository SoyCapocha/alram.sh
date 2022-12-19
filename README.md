# ALRAM.SH
## Why that name?
From the video [garfielf](https://www.youtube.com/watch?v=OGbhJjXl9Rk) made by [PilotRedSun](https://www.youtube.com/@PilotRedSun).
Garfielf hate alram clocks, so i made one just to piss him out.
![alt text](https://github.com/SoyCapocha/alram.sh/blob/main/alramfull.png?raw=true)
## What is this all about?
`alram.sh` is a script written in bash where you can program notifications in a specific day
and time in a easy way without using cronjobs or similar utilities. With the file `.noti` in
your home, you can edit them, set the day, hour, image and sound of the notification so
you don't forget the little tasks that we can pass in our day unintentionally.
## Format of `~/.notis`
```bash
# Comments
# format:
# day month year hour minute second "title" "description" "image ubication" "sound ubication"
19 12 22 17 00 00 "Muh first alram." "yus" "~/alram/alram.png" ""
````
## Dependencies
 - bash
 - date
 - sed
 - awk
 - notify-send
 - SoX
 
The day 19/12/22 at 17:00:00 will send a notification with the name of "Muh first alram.", description "yus", image "~/alram/alram.png" and no sound.
## How this works?
They're two scripts, `alarm.sh` and `alram.sh`. `alarm.sh` administrate the information readed from `~/.notis`. The `~/.notis` file in the end
of each line has an operator that designs the state of this notification. If it hasn't nothing written, then the alarm wasn't executed, so
proceed to open an `alarm.sh` instance with the info from `~/.notis` and write at the end of the line a `[]` so, when `alram.sh` read the square
in that line, it doesn't start a new instance of this alarm.

If the PC is powered off, then, when `alram.sh` it's opened again, remove all the squares and reevaluate the lines, so we don't have to worry about
the `~/.notis` file.

When the alarm is executed, then, at the end of the line of the notification, it will appear a `{}` that indicates that the notification was sended. Then,
`alram.sh` will delete that line and so on.

`alram.sh` cuantify the distance in days from the date that the alarm was designed. If the distance is bigger than one day, then, the program close and
don't make a square of execution, otherwise, it will evaluate the distances in hours and write the square. If the distance is less than one hour, then,
it will being evaluated in minutes, then seconds and lastly, send the notification and remove the line.
