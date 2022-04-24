(define (domain painkiller)
	(:requirements :typing :disjunctive-preconditions :numeric-fluents :timed-initial-literals :durative-actions :duration-inequalities :time :negative-preconditions)
	(:types         
	    location locatable - object
		patient - locatable
		gym home - location
	)
	(:predicates
		(is-at ?p - patient ?l - location)
		(path ?from - location ?to - location)
		(driving) ; checks if the patient is driving
		(safe-to-consume) ; indicates when a dose can be taken ; TODO Empty stomach?
		(safety-check-passed) ; used for safety checking
		(min-check-passed) ; used for minimum pain relief checking
		(end-of-day) ; used to 
		(world-has-not-ended) ; always-true dummy
		(free) ; used instead of a negative precondition (not exercising / not eating)
		
		(went-to-gym) ; used to ensure user drives to the gym 
		
		;(went-to-gym-1) ; used to ensure user drives to the gym and back
		;(went-to-gym-2) ; used to ensure user drives to the gym and back
		;(went-to-gym-3) ; used to ensure user drives to the gym and back
		;(hungry) ; see below
		;(stomach-is-full) ; used to stop the patient from eating multiple meals in a row
		(can-do-normal-actions)
        ;(need-gym-1) ; used to ensure user drives to the gym and back
        ;(need-gym-2) ; used to ensure user drives to the gym and back
        ;(need-gym-3) ; used to ensure user drives to the gym and back
	)
	(:functions
		(half-life) ; the half-life of the drug
		(dose-amount) ; the static amount of the drug that the user can consume
		(number-of-doses-taken-today) ; keeps track of the number of doses consumed
		(max-doses-in-one-day) ; maximum allowed number of doses consumed in a day
		(gap-between-doses) ; the number of time units that must be placed between each two doses
		(time-elapsed) ; time
		(pr) ; the current pain relief, which is equivalent to the amount of the drug in a user's bloodstream
		(min-pr) ; the minimum amount of pain relief we want to give to the user at a given moment
		(max-pr) ; the maximum amount of the drug we can have in a user's bloodstream
		(number-of-meals) ; the number of meals the user had today
		
	)

	; The act of consuming medication
	(:durative-action consume
		:parameters ()
		:duration (= ?duration (gap-between-doses))
		:condition (and 
			(at start (safe-to-consume))
			(at start (can-do-normal-actions))
		)
		:effect (and
			(at start (increase (pr) (dose-amount)))
			(at start (increase (number-of-doses-taken-today) 1))
			(at start (not(safe-to-consume)))
			(at end (safe-to-consume)) ; TODO: Remove
		)
	)

	(:durative-action drive
		:parameters (
			?p - patient
			?from - location
			?to - location
		)
		:duration (= ?duration 20)
		:condition (and 
			(at start (is-at ?p ?from))
			(at start (>= (pr) 250))
			(over all (can-do-normal-actions))
			(at start (free))
		)
		:effect (and
			(at start (not (free)))
			(at end (free))
			(at start (driving))
			(at end (not (driving)))
			(at start (not (safe-to-consume)))
			(at end (safe-to-consume))
			(at start (not (is-at ?p ?from)))
			(at end (is-at ?p ?to))
		)
	)
	
	(:durative-action exercise
		:parameters (
			?p - patient
			?g - gym
		)
		:duration (= ?duration 90)
		:condition (and
			(over all (is-at ?p ?g))
			(at start (>= (pr) 300))
			(over all (can-do-normal-actions))
			(at start (free))
		)
		:effect (and
			(at start (not (free)))
			(at end (free))
			(at end (went-to-gym))
		)
	)

	(:durative-action eat
		:parameters (
			?p - patient
			?h - home
		)
		:duration (= ?duration 40)
		:condition (and 
			(over all (is-at ?p ?h))
			(at start (>= (pr) 200))
			(over all (can-do-normal-actions))
			(at start (free))
		)
		:effect (and
			(at start (not (free)))
			(at end (free))
			(at end (increase (number-of-meals) 1))
		)
	)


(:process decay-1
		:parameters ()
		:precondition (> (pr) 10.0)
		:effect
		(and
			(increase (pr) (* #t (* -1 0.251647445582)))
		)
	)
	
(:process decay-2
		:parameters ()
		:precondition (> (pr) 208.483)
		:effect
		(and
			(increase (pr) (* #t (* -1 1.05490991052)))
		)
	)
	
(:process decay-3
		:parameters ()
		:precondition (> (pr) 515.905)
		:effect
		(and
			(increase (pr) (* #t (* -1 4.12718088199)))
		)
    )

	; If the min-gap isn't big enough, then the problem fails.
	(:event minimum-check
		:parameters ()
		:precondition (and (<= (pr) (min-pr)) (min-check-passed))
		:effect (not(min-check-passed))
	) 
	
)