(define (problem paracetamol)
	(:domain painkiller)
	(:objects
    	eminem - patient
    	puregym othergym - gym
    	penthouse - home
	)
	(:init
		(safe-to-consume)
		(min-check-passed)
		(safety-check-passed)
		(free)
		(is-at eminem penthouse)
		(= (time-elapsed) 0)
		(= (number-of-doses-taken-today) 0)
		(= (number-of-meals) 0)
		(= (max-doses-in-one-day) 4)
		(= (half-life) 180.0)
		(= (dose-amount) 1000.0)
		(= (gap-between-doses) 240.0)
		(= (pr) 300.00)
		(= (max-pr) 3000.0)
		(= (min-pr) 150.0)
		(at 1200 (end-of-day))
		
		(can-do-normal-actions)
		(at 1200 (not (can-do-normal-actions)))
	)
	(:goal
		(and
			(<= (pr) (max-pr))
			(min-check-passed)
			(>= (number-of-doses-taken-today) 3)
			(<= (number-of-doses-taken-today) (max-doses-in-one-day))
			(end-of-day)
			; new goals
			(>= (number-of-meals) 1) ; would like this to be 2
            (went-to-gym)
		)
	)
)