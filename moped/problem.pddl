(define (problem moped_1) 

    (:domain moped)
    (:objects 
        es3 - moped
        b1 b2 - battery
        p1 p2 p3 - parcel
        office store customer - location
    )

    (:init
        ; moped is at the office
        (located es3 office)
        (= (batteryLevel b1) 25)
        (= (batteryLevel b2) 25)
        (using b1)
        (has-charging-port office)

        ; parcels are at the store
        (located p1 store)
        (located p2 store)
        (located p3 store)
    )

    (:goal (and
        ; parcels need to go to the same customer
        (located p1 customer)
        (located p2 customer)
        (located p3 customer)
    ))
)
