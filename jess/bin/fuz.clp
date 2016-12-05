(clear)
(open "./result.txt" file "w")

;;import wymaganych bibliotek i plikow
(import nrc.fuzzy.*)
(import nrc.fuzzy.jess.*)
(load-package FuzzyFunctions)
(batch facts.clp)


(defglobal ?*Dystans* = (new FuzzyVariable "dystans" 100.0 3000.0 "km"))
(defglobal ?*MaxPredkosc* = (new FuzzyVariable "max_predkosc" 0.0 1000.0 "km/h"))
(defglobal ?*Pogoda* = (new FuzzyVariable "pogoda" -1.0 1.0 "pogoda"))

(defglobal ?*OpoznienieLotu* = (new FuzzyVariable "Opoznienie_Lotu" 0.0 10.0 "godziny"))

(defglobal ?*result* = 0)


(defrule init 
 (declare (salience 100))
=>
 (import nrc.fuzzy.*)
 (load-package nrc.fuzzy.jess.FuzzyFunctions)

(bind ?rlf (new RightLinearFunction)) (bind ?llf (new LeftLinearFunction))
    

;;dystans
(?*Dystans* addTerm "maly" (new TrapezoidFuzzySet 100.0 300.0 500.0 600.0))
(?*Dystans* addTerm "sredni" (new TrapezoidFuzzySet 550.0 800.0 1400.0 2000.0))
(?*Dystans* addTerm "duzy" (new TrapezoidFuzzySet 1700.0 2000.0 2500.0 3000.0))

;; Predkosc samolotu
(?*MaxPredkosc* addTerm "niska" (new TrapezoidFuzzySet 300.0 320.0 370.0 400.5))
(?*MaxPredkosc* addTerm "srednia" (new TrapezoidFuzzySet 385.0 410.0 485.0 500.0))
(?*MaxPredkosc* addTerm "wysoka" (new TrapezoidFuzzySet 480.0 520.0 580.0 620.0))
(?*MaxPredkosc* addTerm "maksymalna" (new TrapezoidFuzzySet 600.0 720.0 800.0 900.0))

;; Warunki pogodowe
(?*Pogoda* addTerm "zla" (new TriangleFuzzySet -1.0 -0.5 0.0))
(?*Pogoda* addTerm "normalna" (new TriangleFuzzySet -0.2 0.1 0.4))
(?*Pogoda* addTerm "dobra" (new TriangleFuzzySet 0.2 0.5 1.0))

	
;; opoznienie lotu
(?*OpoznienieLotu* addTerm "brak" (new TriangleFuzzySet 0.0 0.2 0.5))
(?*OpoznienieLotu* addTerm "male" (new TriangleFuzzySet  0.3 1.0 1.5 ))
(?*OpoznienieLotu* addTerm "srednie" (new TriangleFuzzySet 1.4 5.0 7.0 ))
(?*OpoznienieLotu* addTerm "duze" (new TriangleFuzzySet 6.7 8.0 10.0))


(printout file "" crlf)
(printout file "Expert System for aviation industry " crlf) 
(printout file "" crlf)
(printout file "Flight delays in hours" crlf) 
(printout file "" crlf)

;; dystans lotu
(assert (crispDyst_Lotu ?*distance*))
(assert (DystLotu (new FuzzyValue ?*Dystans* (new TrapezoidFuzzySet ?*distance* ?*distance* ?*distance* ?*distance*))))

;; predkosc lotu
(assert (crispMax_Pr ?*speed*))
(assert (MaxPredkosc (new FuzzyValue ?*MaxPredkosc* (new TrapezoidFuzzySet ?*speed* ?*speed* ?*speed* ?*speed*))))

;; pogoda
(assert (crispPogo ?*weather*))
(assert (Pogod (new FuzzyValue ?*Pogoda* (new TriangleFuzzySet ?*weather* ?*weather* ?*weather*))))


)

(defrule regula1
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "niska"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))


(defrule regula2
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "niska"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "srednie"))))

(defrule regula3
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "niska"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "srednie"))))

(defrule regula4
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "srednia"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula5
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "srednia"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

(defrule regula6
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "srednia"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

(defrule regula7
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "wysoka"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula8
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "wysoka"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

(defrule regula9
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "wysoka"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

(defrule regula10
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "maksymalna"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula11
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "maksymalna"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

(defrule regula12
(DystLotu ?dst&:(fuzzy-match ?dst "maly"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "maksymalna"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

;; --- sredni dystans
(defrule regula13
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "niska"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "duze"))))

(defrule regula14
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "niska"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "srednie"))))

(defrule regula15
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "niska"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula16
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "srednia"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula17
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "srednia"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula18
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "srednia"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

(defrule regula19
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "wysoka"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "srednie"))))

(defrule regula20
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "wysoka"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula21
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "wysoka"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

(defrule regula22
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "maksymalna"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula22
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "maksymalna"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

(defrule regula23
(DystLotu ?dst&:(fuzzy-match ?dst "sredni"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "maksymalna"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

;; --------- duzy dystans
(defrule regula24
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "niska"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "duze"))))

(defrule regula25
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "niska"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "srednie"))))

(defrule regula26
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "niska"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "srednie"))))

(defrule regula27
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "srednia"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "srednie"))))

(defrule regula28
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "srednia"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula29
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "srednia"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

(defrule regula30
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "wysoka"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula31
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "wysoka"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula32
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "wysoka"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))

(defrule regula33
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "maksymalna"))
(Pogod ?pgd&:(fuzzy-match ?pgd "zla"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "srednie"))))

(defrule regula34
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "maksymalna"))
(Pogod ?pgd&:(fuzzy-match ?pgd "normalna"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "male"))))

(defrule regula35
(DystLotu ?dst&:(fuzzy-match ?dst "duzy"))
(MaxPredkosc ?mpr&:(fuzzy-match ?mpr "maksymalna"))
(Pogod ?pgd&:(fuzzy-match ?pgd "dobra"))
=>
(bind ?*result* 1)
(assert (opoznienie_l (new FuzzyValue ?*OpoznienieLotu* "brak"))))


;;regula odpowiadajaca za proces wnioskowania rozmytego, nastepuje tutaj defuzyfikacja, wnioskowanie, wyostrzanie, zapisanie wynikow do pliku
(defrule control
(declare (salience -100))

?zDist <- (crispDyst_Lotu ?dst)
?zMaxPr <- (crispMax_Pr ?mpr)
?zPogo <- (crispPogo ?pgd)

?opozn <- (opoznienie_l ?fuzzyOpoznienieL)

=>
   
    (bind ?crispOpoznienie_Lotu (?fuzzyOpoznienieL momentDefuzzify))
    
    (printout file "" crlf)
    (printout file "Distance = " ?dst " , speed  = " ?mpr  ", weather condition = " ?pgd crlf)
    
        
  
    
    (bind ?zmienna1 (* ?crispOpoznienie_Lotu 1))
    
    
   (bind ?aaa (round  (* ?zmienna1 100)))
    
   (bind ?aaaa (/ ?aaa 100))
   
    (printout file "" crlf)
    
    (printout file "Delay  : " ?aaaa " hours "crlf)  
    
         
    
    )

(reset)
(run)

(close file)

