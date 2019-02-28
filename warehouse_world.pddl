(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
        :parameters (?r - robot ?loc1 - location ?loc2 - location)
        :precondition (and (free ?r) 
                            (at ?r ?loc1) 
                            (no-robot ?loc2)
                            (connected ?loc1 ?loc2))
        :effect (and (at ?r ?loc2)
                        (no-robot ?loc1)
                        (not (free ?r))
                        (not (at ?r ?loc1))
                        (not (no-robot ?loc2)))
   )
   
   (:action robotMoveWithPallette
        :parameters (?r - robot ?loc1 - location ?loc2 - location ?p - pallette)
        :precondition (and (free ?r) 
                            (at ?r ?loc1) 
                            (no-robot ?loc2)
                            (at ?p ?loc1)
                            (no-pallette ?loc2)
                            (connected ?loc1 ?loc2))
        :effect (and (at ?r ?loc2)
                        (no-robot ?loc1)
                        (at ?p ?loc2)
                        (has ?r ?p)
                        (not (free ?r))
                        (not (at ?r ?loc1))
                        (not (at ?p ?loc1))
                        (not (no-robot ?loc2))
                        (not (no-pallette ?loc2)))
   )
   
   (:action moveItemFromPalletteToShipment
        :parameters (?loc - location ?ship - shipment ?si - saleitem ?p - pallette ?o - order)
        :precondition (and (orders ?o ?si) 
                            (available ?loc) 
                            (packing-location ?loc) 
                            (no-pallette ?loc)
                            (contains ?p ?si) 
                            (available ?loc)) 
        :effect (and (ships ?ship ?o)
                        (includes ?ship ?si)
                        (packing-at ?ship ?loc)
                        (at ?p ?loc)
                        (not (available ?loc))
                        (not (no-pallette ?loc)))
   )
   
   (:action completeShipment
        :parameters (?ship - shipment ?o - order ?loc - location)
        :precondition: (and (started ?ship)
                                (packing-at ?ship ?loc))
        :effect: (and (complete ?ship)
                        (not (started ?ship))
                        (not (packing-at ?ship ?loc)))
   )
)








