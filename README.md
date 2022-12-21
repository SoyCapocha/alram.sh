# ALRAM.SH
## Why that name?
From the video [garfielf](https://www.youtube.com/watch?v=OGbhJjXl9Rk) made by [PilotRedSun](https://www.youtube.com/@PilotRedSun).
Garfielf hates alram clocks, so i made one just to piss him out.
![alt text](https://github.com/SoyCapocha/alram.sh/blob/main/alramfull.png?raw=true)
## What is this all about?
`alram.sh` and `alarm.sh` are scripts made in bash where you can program notifications in
a specific day and time in a easy way without using cronjobs or similar utilities. Editing
the `~/.notis` file you can add notifications setting the day, hour, image and sound
for the notification so you don't forget the little tasks that we can pass in our day
unintentionally.
 the little tasks that we can pass in our day unintentionally.
## Installation
Copy `alram.sh` and `alarm.sh` in your scripts folder, make executables and add it to your path.
## Use
First we need to configure an alarm, so we edit the `~/notis` file calling `alram.sh e`, so it
will generate an generic demo file with the sintaxis of our alarm. It's important that if
we don't use description, image or sound, let an empty double quotes, otherwise, it won't work.
### Format of `~/.notis`
```bash
# Comments
# format:
# day month year hour minute second "title" "description" "image ubication" "sound ubication"
19 12 22 17 00 00 "Muh first alram." "yus" "~/alram/alram.png" ""
````
So, the day 19/12/22 at 17:00:00 will send a notification with the name of "Muh first alram.", description "yus", image "~/alram/alram.png" and no sound.
### example
https://user-images.githubusercontent.com/33698389/208787588-227e2558-0054-4bad-a897-9b1d99e96021.mp4
## Dependencies
 - bash
 - date
 - sed
 - awk
 - notify-send
 - SoX 

## How this works?
They're two scripts, `alram.sh` and `alarm.sh`. `alram.sh` administrate the information readed from `~/.notis`. The `~/.notis` file in the end
of each line has an operator that designs the state of this notification. If it hasn't nothing written, then the alarm wasn't executed, so
proceed to open an `alarm.sh` instance with the info from `~/.notis` and write at the end of the line a `[]` so, when `alram.sh` read the square
in that line, it doesn't start a new instance of this alarm.

If the PC is powered off, then, when `alram.sh` it's opened again, remove all the squares and reevaluate the lines, so we don't have to worry about
the `~/.notis` file.

When the notification is sended, then, at the end of the line of the notification declared in `~/.notis`, it will appear a `{}` that indicates that the notification was sended. Then,
`alram.sh` will delete that line the next day and so on.

`alarm.sh` cuantify the distance in days from the date that the alarm was designed. If the distance is bigger than one day, then, the program close and
don't make a loop execution.If the distance is less than one hour, the square will be marked and start evaluating the distance in minutes. If the distance is less than 2 minutes, then it will evaluate in seconds. Finally send the notification and set the `{}` at the end of the line.

