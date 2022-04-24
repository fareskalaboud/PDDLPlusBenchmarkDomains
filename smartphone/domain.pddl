(define (domain smartphone)
	(:requirements ...) ; omitted for space
	(:types smartphone)
	(:predicates (charging ?s - smartphone) (task-complete))

	(:functions (batteryLevel ?s - smartphone) (capacity ?s - smartphone) (task-completion))

	(:durative-action use
	 :parameters (?s - smartphone)
	 :duration (>= ?duration  1)
	 :condition (and (over all (>= (batteryLevel ?s) 1))(over all (not (charging)) ))
	 :effect (and  (decrease (batteryLevel ?s) (* #t -5)) (increase (task-completion) (* #t 1)) )
	)

    (:action plug
     :parameters (?s - smartphone)
     :precondition (and  (not (charging ?s)) (< (batteryLevel ?s) (capacity ?s) ))
     :effect (and (charging ?s) )
    )

    (:action unplug
     :parameters (?s - smartphone)
     :precondition (and (charging ?s) )
     :effect (and (not (charging ?s)) )
    )

	(:process charging_0
	 :parameters (?s - smartphone)
	 :precondition (and (charging ?s))
	 :effect (and (increase (batteryLevel ?s) (* #t 0.3)))
	)

	(:process charging_1
	 :parameters (?s - smartphone)
	 :precondition (and (< (batteryLevel ?s) 700) (charging ?s))
	 :effect (and (increase (batteryLevel ?s) (* #t 0.7)))
	)
	
	(:process charging_2
	 :parameters (?s - smartphone)
	 :precondition (and (< (batteryLevel ?s) 500) (charging ?s))
	 :effect (and (increase (batteryLevel ?s) (* #t 1)))
	)

    (:event complete
     :parameters ()
     :precondition (and (>= (task-completion) 100))
     :effect (and (task-complete))
    )
)

