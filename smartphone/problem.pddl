(define (problem smartphone_0)

    (:domain smartphone)
    (:objects smartphone - galaxynote20ultra)

    (:init 	
      (= (batteryLevel galaxynote20ultra) 10)
      (= (capacity galaxynote20ultra) 100)
      (= (task-completion) 0)
     )  

     (:goal (task-complete))
)
