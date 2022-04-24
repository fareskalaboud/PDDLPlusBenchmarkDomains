(define (domain painkiller)
    (:requirements :typing :disjunctive-preconditions :numeric-fluents :timed-initial-literals :durative-actions :duration-inequalities :time :negative-preconditions)
    (:predicates
        (safe-to-consume)  ; indicates when a dose can be taken
        (pr-check)  ; used for minimum pain relief checking
        (end-of-day)  ; used to determine the planning horizon
    )
    (:functions
        (dose-amount) ; the static amount of medicine that user can consume
        (doses) ; keeps track of the number of doses consumed
        (gap) ; time units that must elapse between each two doses
        (pr) ; the current pain relief
        (min-pr) ; the minimum amount of pain relief we want
        (half-life) ; the half-life of the drug
		    (max-doses) ; maximum number of doses consumed in a day
    )

    ; The act of consuming medication
    (:durative-action consume
        :parameters ()
        :duration (= ?duration (gap))
        :condition (and
            (at start (safe-to-consume))
            (at start (not(end-of-day)))
            (at end (not(end-of-day)))
        )
        :effect (and
            (at start (increase (pr) (dose-amount)))
            (at start (increase (doses) 1))
            (at start (not(safe-to-consume)))
            (at end (safe-to-consume))
        )
    )

    (:process decay-1
        :parameters ()
        :precondition (> (pr) 10.0)
        :effect (and
            (increase (pr) (* #t (* -1 0.251647445582)))
        )
    )

    (:process decay-2
        :parameters ()
        :precondition (> (pr) 208.483)
        :effect (and
            (increase (pr) (* #t (* -1 1.05490991052)))
        )
    )

    (:process decay-3
        :parameters ()
        :precondition (> (pr) 515.905)
        :effect (and
            (increase (pr) (* #t (* -1 1.96048832709)))
        )
    )

    (:process decay-4
        :parameters ()
        :precondition (> (pr) 1299.99)
        :effect (and
            (increase (pr) (* #t (* -1 4.56121595656)))
        )
    )

    ; If the min-gap isn't big enough, then the problem fails.
    (:event prfailure
        :parameters ()
        :precondition (and (<= (pr) (min-pr)) (pr-check))
        :effect (not(pr-check))
    )
)
