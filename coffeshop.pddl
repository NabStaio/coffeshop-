;Header and description

(define (domain coffeshop)

;remove requirements that are not needed
(:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality)

(:types drink hand tray robot waypoint

(:predicates    (warm ?x-drink)
                (cold ?x-drink)
                (ready ?x-drink)
                (free ?h – hand)
                (holding ?x-drink ?h-hand)
                (onbar ?t – tray)
                (carry ?t-tray ?h-hand)
                (at ?waiter ?waypoint)
                (on ?x – drink ?t – tray)
                (order ?x-drink ?waypoint)
		        ;(clear ?t -tray)
                (robot ?waiter)
                (waypoint ?waypoint)
                (can move ?from-waypoint ?to-waypoint)
                (been-at ?waiter ?waypoint)
                (dirty ?t-table)
                ;(ontable ?x – drink)
)

(:functions (numdrink)
            (distance)
            (speed)
)

;ROBOT BARMAN:
;(:action pick-up
;	:parameters (?x -drink ?hand-hand)
;	:precondition (and
;        (ontable ?x) (free ?hand) (empty ?x)
;    )
;	:effect(and
;        (holding ?x ?hand)
;        (not(ontable ?x)) (not (free ?hand)) 
;    )
;)

(:durative-action fillwarm
	:parameters (?x-drink)
	:duration (= ?duration 5)
	:condition (and 
        (at start (not(ready ?x)))
        (at start (warm ?x))
    )
	:effect (and 
        (at end (ready ?x))
        
    )
)

(:durative-action fillcold
	:parameters (?x-drink)
	:duration (= ?duration 3)
	:condition (and 
        (at start (not(ready ?x)))
        (at start (cold ?x))
    )
	:effect (and 
        (at end (ready ?x))
    )
)

;(:action put-down
;	:parameters (?x -drink ?hand-hand)
;	:precondition (and
;        (holding ?x ?hand)  (full ?x)
;    )
;	:effect (and
;        (ontable ?x) (free ?hand) 
;        (not(holding ?x ?hand))
;    )
;)

;ROBOT WAITER:
(:action pick-upD
	:parameters (?x -drink ?hand-hand ?bar-waypoint ?waiter-robot)
	:precondition (and
         (free ?hand) (ready ?x) (at ?waiter ?bar) 
    )
	:effect(and
        (holding ?x ?hand)
        (not (free ?hand)) (not(at ?waiter ?bar))
    )
)

(:action pick-upT
	:parameters (?tray -tray ?hand-hand ?bar-waypoint ?waiter-robot)
	:precondition (and
        (onbar ?tray) (free ?hand) (at ?waiter ?bar)
    )
	:effect (and
        (carry ?tray ?hand)
        (not(onbar ?tray)) (not (free ?hand))
    )
)
;controllo con variabile numerica
(:action stack
    :parameters (?x- drink ?tray-tray ?hand-hand ?bar-waypoint ?waiter-robot)
    :precondition (and 
    (carry ?tray ?hand) (ready ?x) (at ?waiter ?bar) 
    ;controllo numero di drink  
    )
    :effect(and
        (on ?x ?tray)
        (increase (numdrink))   
        ;incrementa numero 
    )
)

(:action put-downD
	:parameters (?x -drink ?hand-hand ?table-waypoint)
	:precondition (and
        (holding ?x ?hand) (at ?waiter ?table) (order ?x ?table)
    )
	:effect (and
        (free ?hand) (dirty ?table)
        (not(holding ?x ?hand)) (not(at ?waiter ?table)) (not(order ?x ?table))
    )
)

(:action put-downT
	:parameters (?hand-hand ?tray-tray ?waiter-robot ?bar-waypoint)
	:precondition (and
        (carry ?tray ?hand) (at ?waiter ?bar) 
    )
	:effect (and
        (onbar ?tray) (free ?hand) 
        (not(carry ?tray ?hand))
    )
)

(:action unstack
    :parameters (?x-drink ?tray-tray ?hand-hand)
    :precondition (and 
        (free ?hand) (on ?x ?tray)
    )
    :effect (and 
        (holding ?x ?hand) (clear ?tray) (ontable ?x)
        (not(free ?hand)) (not (on ?x ?tray))
    )
)

;duration=distance/velocity
(:durative-action move
	:parameters(?waiter-robot ?from-waypoint ?to-waypoint ?x-drink)
	:duration(= ?duration (/ (distance) (speed)))
	:condition (and
        (at start (robot ?waiter)) (at start(waypoint ?from-waypoint)) 
        (at start(waypoint ?to-waypoint)) 
        (over all(can move ?from-waypoint ?to-waypoint)) 
        (at start(at ?waiter ?from-waypoint))
    )
    :effect(and
        (at end (at ?waiter ?to-waypoint)) (at end (been-at ?waiter ?to-waypoint))
        (at end (order ?x ?to-waypoint))
        (at start (not(at ?waiter ?from-waypoint)))
    )
)

(:durative-action moveT
	:parameters(?waiter-robot ?from-waypoint ?to-waypoint ?x-drink ?tray-tray ?hand-hand)
	:duration(= ?duration (/ (distance) (speed)))
	:condition (and
        (at start (robot ?waiter)) (at start(waypoint ?from-waypoint)) 
        (at start(waypoint ?to-waypoint)) 
        (over all(can move ?from-waypoint ?to-waypoint)) 
        (at start(at ?waiter ?from-waypoint)) (at start(carry ?tray ?hand))
    )
    :effect(and
        (at end (at ?waiter ?to-waypoint)) (at end (been-at ?waiter ?to-waypoint))
        (at end (order ?x ?to-waypoint))
        (at start (not(at ?waiter ?from-waypoint)))
    )
)

(:action clean
    :parameters (?table-waypoint)
    :precondition(and 
        (dirty ?table)
    )
    :effect(and
        (not(dirty ?table))
    )























