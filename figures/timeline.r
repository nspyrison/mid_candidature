
# TODO: Cut out RO 2 and adjust RO 3,4 accordingly.
#

## working from: https://stats.andrewheiss.com/misc/gantt.html
library(tidyverse)
library(lubridate)
library(scales)

tasks <- tribble(
  ~Start,       ~End,         ~Project,     ~Task,
  "2018-04-01", "2019-06-01", "1) 2D UCS",  "1) 2D UCS",
  "2018-04-01", "2019-02-01", "1) 2D UCS",  "1) code",
  "2018-12-01", "2019-06-01", "1) 2D UCS",  "1) paper (The R journal)",
  "2019-01-01", "2019-03-01", "Milestones", "Candidature confirmation",

  "2019-03-01", "2019-12-01", "3) 3D UCS",  "3) 3D UCS",
  "2019-03-01", "2019-08-01", "3) 3D UCS",  "3) code",
  "2019-06-01", "2019-12-01", "3) 3D UCS",  "3) paper (VAST)",
  "2020-01-01", "2020-03-01", "Milestones", "Mid candidature review",

  "2019-10-01", "2020-09-01", "4) UCS 2D vs 3D", "4) UCS across display type",
  "2019-10-01", "2020-02-01", "4) UCS 2D vs 3D", "4) code",
  "2020-01-01", "2020-04-01", "4) UCS 2D vs 3D", "4) experimental survey",
  "2020-03-01", "2020-09-01", "4) UCS 2D vs 3D", "4) paper (CHI)",

  "2020-04-01", "2020-12-01", "2) UCS vs alts", "2) UCS vs alternatives",
  "2020-04-01", "2020-08-01", "2) UCS vs alts", "2) code",
  "2020-06-01", "2020-12-01", "2) UCS vs alts", "2) paper (VAST)",


  "2020-11-01", "2021-03-01", "Milestones", "pre-submission presentation",
  "2020-09-01", "2021-04-01", "Milestones", "thesis composition"
)

# Convert data to long for ggplot
tasks.long <- tasks %>%
  mutate(Start = ymd(Start),
         End = ymd(End)) %>%
  gather(date.type, task.date, -c(Project, Task)) %>%
  #arrange(date.type, task.date) %>%
  mutate(Task = factor(Task, levels=rev(unique(Task)), ordered=T))
# Custom theme for making a clean Gantt chart
theme_gantt <- function(base_size=11) {
  ret <- theme_bw(base_size) %+replace%
    theme(panel.background = element_rect(fill="#ffffff", colour=NA),
          axis.title.x=element_text(vjust=-0.2), axis.title.y=element_text(vjust=1.5),
          title=element_text(vjust=1.2),
          panel.border = element_blank(), axis.line=element_blank(),
          panel.grid.minor=element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.major.x = element_line(size=0.5, colour="grey80"),
          axis.ticks=element_blank(),
          legend.position="bottom",
          axis.title=element_text(size=rel(0.8)),
          strip.text=element_text(size=rel(1)),
          strip.background=element_rect(fill="#ffffff", colour=NA),
          panel.spacing.y=unit(1.5, "lines"),
          legend.key = element_blank())

  ret
}

# Calculate where to put the dotted lines that show up every three entries
x.breaks <- seq(length(tasks$Task) + 0.5 - 3, 0, by=-3)

# Build plot
timeline <- ggplot(tasks.long, aes(x=Task, y=task.date, colour=Project)) +
  geom_line(size=6) +
  geom_vline(xintercept=x.breaks, colour="grey80", linetype="dotted") +
  guides(colour=guide_legend(title=NULL)) +
  labs(x=NULL, y=NULL) + coord_flip() +
  scale_y_date(date_breaks="2 months", labels=date_format("%b ‘%y")) +
  theme_gantt() + theme(axis.text.x=element_text(angle=45, hjust=1)) +
  scale_color_brewer(palette = "Dark2") +
  theme(axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        legend.text = element_text(size = 12))

timeline
#TODO: Save off .png and hard code figure.


# ## Accompanying documents
#
# - FIT 5144 hours
#     - \>120 hours __Tracked, awaiting mandatory events__, due at the mid-candidature review
# - WES Academic record
#     - FIT6021: 2018 S2, **Completed** with distinction
#     - FIT5144: 2019 S1+2, **Upcoming**, due at mid-candidature review
#     - FIT5113: 2018 S2, **Exemption** #(submitted:08/2018, recorded 4/2019)
# - myDevelopment - IT: Monash Doctoral Program - Compulsory Module
#     - Monash Graduate Research Student Induction: **Completed**
#     - Research Integrity - Choose the Option most relevant: **Completed** (2 required of 4)
#     - Faculty Induction: **Content unavailable** (01/04/2019: "Currently being updated and will be visible in this section soon")
#
# <!-- Induction To be completed within 6 months of commencement -->


