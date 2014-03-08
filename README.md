Automated Marking System
========================

The Automated Marking System (**AMS**) is intended to provide an easy to use web interface that teachers, teaching assistants, and students can use to mark assignments for courses that involve programming.


Project Goals
--------------

The automated marking system has four main goals that guide the design and development of the system.

1. Scalability
2. Automated marking
3. Quality feedback
4. Cheating detection


### Scalability

The system must be scalable to support hundreds of students or more with added nodes to the cloud. Redis is used to create a high performance scalable distributed job queue that can be accessed by compile/compute nodes which compile and evaulate the code.


### Automated Marking

The system will provide automated compilation and execution of code with automated output parsing used to compare the input provided against exemplar output used to evaluate the accuracy of the code.

A web interface will provide a way for students to submit assignments and receive feedback instantly. There will be A separate provision for TAs and professors will allow for the dissemination of assignments, viewing grades, and examining suspected cheating.


### Quality Feedback

Static analysis of code is done using well-known metrics and widely adopted lint tools, for C++ analysis we are using the *cppcheck* tool. The system will provide feedback on the quality of the code using the metrics provided by the tools, and professors have the option to have the static analysis tools factor into the overall grading of assignments.


### Cheating Detection

Cheating detection is implemented using code cloning techniques and differential analysis of code to determine with statisical significance incidents of cheating that have occurred. Reports are generated giving a percentage confidence for all incidents of cheating detected, which teaching assistants can use as a starting point for further review.


Copyright (Really Copyleft)
---------------------------

All of the source code in this repository, is licensed under the 
[GNU General Public License, Version 3](http://www.gnu.org/licenses/gpl.html)
