# detroit-spiritual-healing-services

## Overview

You run a software development agency. A client of yours, Detroit Spiritual Healing Services, has asked you to build an application to help manage its operations.

Detroit Spiritual Healing Services (DSHS) offers services such as mind reading, demonic exorcism, potion therapy, and liver transplants.
DSHS is staffed by a receptionist and five service professionals licensed by the Michigan Board of Freaky Medicine.

Because DSHS is philosophically opposed to graphical UIs, they have asked for a command-line-only application.

##  Desired features

### Add/remove services

Each service has a name, price and length.

### Add/remove service providers

Each service provider has a name, phone number and list of services provided.

### Schedule appointment

Need to keep track of when the appointment happens, what services it is, what client the appointment is with and which service provider the appointment is with.
If the appointment conflicts with another appointment, it should not be allowed to be scheduled.
If the selected service provider does not offer the specified service, the appointment should not be allowed to be scheduled.

Some clients have standing appointments that occur e.g. every Tuesday at 2pm in perpetuity.

### Create/delete availability block

Not every service provider is available all the time.
We need the ability to track recurring days off as well as one-offs.

### View schedule

You should be able to view a schedule for any particular service provider for a particular day.
The schedule view should include existing appointments as well as unscheduled available time.

## Implementation guidance

You can use a library called [TTY::Prompt](https://github.com/piotrmurach/tty-prompt) to help with the command-line interface portions of the application.

Below is a small TTY::Prompt example. If you were to put the code below in a file called `program.rb`, you would run it by running `ruby program.rb` on the command line.

```ruby
require 'tty-prompt'

prompt = TTY::Prompt.new

date                  = prompt.ask('Date:')
start_time            = prompt.ask('Start time:')
service_provider_name = prompt.ask('Service provider name:')
```


# Week 2 Story
## Inherited project: Rifty, Jessica & Tatiana

### What Is Done
- Add Services 
- List Services Provider

### What Needs To Be Done
- Add Service Provider -- should we check if it is a valid phone number? it can take any phone number at th moment The adding service part of this is done too. Change up how to navigate and select stuff in the menu. Also need to fix the part that has empty select areas when you add a new service, a blank service provider can be made. 
- Schedule Time Off -- we can't check if it works because schedule appointment doesn't works in the first place
- View Schedule -- we can't check if it works because schedule appointment doesn't works in the first place
   - we didn't have any valid services earlier.... this area actually works
   
### What We Want To Get Done for 6/7/2019
- Moving things from one folder to another folder -- because it was originally built in a way where there were two folders
- Remove Service Provider -- blank continues fix
- Schedule Appointment -- How to assign a service provider to a service, This area doesn't work.
- An option to end the program without the bad UI.
- Ask to enter their name because that's something someone thinks of when it comes to scheduling things
