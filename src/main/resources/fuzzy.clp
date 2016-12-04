(clear)
(open "./wyniki.txt" file "w")

;;import wymaganych bibliotek i plikow
(import nrc.fuzzy.*)
(import nrc.fuzzy.jess.*)
(load-package FuzzyFunctions)
(batch facts.clp)

;;deklaracja zmiennych rozmytych
(defglobal ?*DistanceVar* = (new FuzzyVariable "distance" 0.0 5000.0 "km"))
(defglobal ?*SpeedVar* = (new FuzzyVariable "speed" 100.0 1000.0 "km/h"))
(defglobal ?*WeatherVar* = (new FuzzyVariable "weather" -2.0 2.0 "weather"))
;; ---nieuzywane---
;;(defglobal ?*CrewVar* = (new FuzzyVariable "crew" 0.0 40.0 "years"))
;;(defglobal ?*AirportVar* = (new FuzzyVariable "airport" -1.0 1.0 "airpotr"))
;;(defglobal ?*PassengersVar* = (new FuzzyVariable "passengers" 1.0 500.0 "count"))

(defglobal ?*DelayVar* = (new FuzzyVariable "delay" 0 10 "h"))

(defglobal ?*tempus* = 0)

;;regula startowa inicjujaca proces wnioskowania rozmytego
(defrule init
 (declare (salience 100))
=>
 (import nrc.fuzzy.*)
 (load-package nrc.fuzzy.jess.FuzzyFunctions)

(bind ?rlf (new RightLinearFunction)) (bind ?llf (new LeftLinearFunction))





;;-----------------------------------------------------------------------------------------
;;rozmywanie na przedzialy kazdej zmiennej
;; dystans
(?*DistanceVar* addTerm "very_short" (new TrapezoidFuzzySet 0.0 250.0 750.0 1000.0))
(?*DistanceVar* addTerm "short" (new TrapezoidFuzzySet 800.0 1200.0 1600.0 2000.0))
(?*DistanceVar* addTerm "medium" (new TrapezoidFuzzySet 1900.0 2250.0 2700.0 3000.0))
(?*DistanceVar* addTerm "long" (new TrapezoidFuzzySet 2700.0 3000.0 3500.0 4000.0))
(?*DistanceVar* addTerm "very_long" (new TrapezoidFuzzySet 3800.0  4200.0 4650.0 5000.0))

;; max. predkosc lotu
(?*DistanceVar* addTerm "very_slow" (new TrapezoidFuzzySet 100.0 200.0 300.0 400.0))
(?*DistanceVar* addTerm "slow" (new TrapezoidFuzzySet 380.0 450.0 520.0 600.0))
(?*DistanceVar* addTerm "medium_speed" (new TrapezoidFuzzySet 575.0 620.0 680.0 700.0))
(?*DistanceVar* addTerm "fast" (new TrapezoidFuzzySet 680.0 750.0 800.0 850.0))
(?*DistanceVar* addTerm "very_fast" (new TrapezoidFuzzySet 830.0  900.0 950.0 1000.0))

;; warunki pogodowe
(?*WeatherVar* addTerm "very_bad" (new TriangleFuzzySet -2.0 -2.0 -1.0))
(?*WeatherVar* addTerm "bad" (new TriangleFuzzySet -2.0 -1.0 0.0))
(?*WeatherVar* addTerm "normal" (new TriangleFuzzySet -1.0 0.0 1.0))
(?*WeatherVar* addTerm "good" (new TriangleFuzzySet 0.0 1.0 2.0))
(?*WeatherVar* addTerm "very_good" (new TriangleFuzzySet 1.0 2.0 2.0))

;; opoznienie lotu ----
(?*DelayVar* addTerm "very_low" (new TriangleFuzzySet 0.0 1.0 2.0))
(?*DelayVar* addTerm "low" (new TriangleFuzzySet 1.5 2.0 3.0))
(?*DelayVar* addTerm "medium" (new TriangleFuzzySet 2.8 4.0 5.0))
(?*DelayVar* addTerm "big" (new TriangleFuzzySet 4.0 5.5 7.0))
(?*DelayVar* addTerm "very_big" (new TriangleFuzzySet 6.5 8.0 10.0))


(printout file "" crlf)
(printout file "Expert Sytem for aviation industry" crlf)
(printout file "" crlf)
(printout file "Determines delay of flights (in hours) " crlf)
(printout file "" crlf)


;; --------- wczytanie zm. z pliku
;; dystans
(assert (crispDist ?*distance*))
(assert (Dist (new FuzzyValue ?*DistanceVar* (new TrapezoidFuzzySet ?*distance* ?*distance* ?*distance* ?*distance*))))

;; predkosc
(assert (crispSp ?*speed*))
(assert (Sp (new FuzzyValue ?*SpeedVar* (new TrapezoidFuzzySet ?*speed* ?*speed* ?*speed* ?*speed*))))

;; pogoda
(assert (crispWeath ?*weather*))
(assert (Weath (new FuzzyValue ?*WeatherVar* (new TriangleFuzzySet ?*weather* ?*weather* ?*weather*))))


)


(defrule regula1
(Dist ?dt&:(fuzzy-match ?dt "very_short"))
(Sp ?sp&:(fuzzy-match ?sp "very_slow"))
(Weath ?wt&:(fuzzy-match ?wt "very_bad"))
=>
(bind ?*tempus* 1)
(assert (Delay (new FuzzyValue ?*DelayVar* "big"))))


;; --------------------------------------------------------------------------------------------
;;regula odpowiadajaca za proces wnioskowania rozmytego, nastepuje tutaj defuzyfikacja, wnioskowanie, wyostrzanie, zapisanie wynikow do pliku
(defrule control
(declare (salience -100))

?dist <- (crispDist ?dt)
?speed <- (crispSp ?sp)
?weather <- (crispWeath ?wt)


?delay <- (Delay ?fuzzyDelay)


=>

    (bind ?crispDelay (?fuzzyDelay momentDefuzzify))


	;;wyswietlanie wynikow wnioskowania w konsoli
    (printout file "" crlf)
    (printout file "Distance = " ?dt " , speed = " ?sp " , weather = " ?wt "  crlf)




    (bind ?zmienna1 (* ?crispDelay 1))



    ;;zaokraglanie wynikow do 2 miejsc po przecinku
   (bind ?aaa (round  (* ?zmienna1 100)))

   (bind ?aaaa (/ ?aaa 100))


	;;wyswietlanie wynikow w formie procentowej - do 100%
    (printout file "" crlf)

    (printout file "Estimated delay : " ?aaaa crlf)



    )




;;zaladowanie faktow do pamieci roboczej jess i uruchomienie mechanizmu wnioskowania
(reset)
(run)

(close file)
