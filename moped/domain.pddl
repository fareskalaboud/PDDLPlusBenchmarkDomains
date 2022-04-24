(define (domain moped)
    (:requirements ...) ;omitted to save space

    (:types
        location locatable - object
        parcel moped - locatable
        battery - battery
    )

    (:predicates
        (charging ?m - moped)
        (using ?b - battery)
        (free ?m - moped)
        (driving ?m)
        (has-charging-port ?l - location)
        (located ?p - locatable ?l - location)
    )

    (:functions
        (batteryLevel ?b - battery)
    )

    (:process kinetic-charge
        :parameters ( ?m - moped ?b - battery )
        :precondition (and  (driving ?m)    (not (using ?b)))
        :effect (and    (increase (batteryLevel ?b) (* #t 1)))
    )

    (:process idle
        :parameters ( ?m - moped ?b - battery )
        :precondition (and (not (driving ?m)) (using ?b) )
        :effect (and (increase (batteryLevel ?b) (* #t -2)) )
    )

    (:process driving
        :parameters ( ?m - moped ?b - battery )
        :precondition (and (driving ?m) (using ?b) )
        :effect (and (increase (batteryLevel ?b) (* #t -4)) )
    )

    (:durative-action drive
        :parameters ( ?from - location ?to - location ?m - moped )
        :duration (= ?duration 10)
        :condition (and (over all (not (charging ?m))) (at start (not (driving ?m))) (at start (located ?m ?from)) )
        :effect (and (at start (driving ?m)) (at start (not (located ?m ?from))) (at end (not (driving ?m))) (at end (located ?m ?to)) )
    )

    (:durative-action fast-charge
        :parameters ( ?b - battery ?l - location ?m - moped )
        :duration (= ?duration 20)
        :condition (and (at start (located ?m ?l)) (at start (has-charging-port ?l)) (at start (not (charging ?m))) (over all (not (driving ?m))) )
        :effect (and (at start (charging ?m)) (at end (increase (batteryLevel ?b) 50)) (at end (not (charging ?m))) )
    )

    (:action switch-battery
        :parameters ( ?m - moped ?b1 - battery ?b2 - battery )
        :precondition (and (not (driving ?m)) (not (charging ?m)) (not (using ?b1)) (using ?b2) )
        :effect (and (using ?b1) (not (using ?b2)) )
    )

    (:action pick-up
        :parameters ( ?m - moped ?p - parcel ?l - location )
        :precondition (and (free ?m) (located ?m ?l) (located ?p ?l) )
        :effect (and (not (free ?m)) (located ?p ?m) )
    )

    (:action deliver
        :parameters ( ?m - moped ?p - parcel ?l - location )
        :precondition (and (located ?m ?l) (located ?p ?m) )
        :effect (and (free ?m) (located ?p ?l) )
    )
)