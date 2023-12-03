;***********************
;***** FUNCIONES *******
;***********************

(deffunction question (?question)
    (format t "%s" ?question)
    (bind ?answer (read))
    ?answer
)

;***********************
;******** MAIN *********
;***********************

(defmodule MAIN (export ?ALL))

(defrule initial
    =>
    (printout t crlf "*** Bienvenidos al recomendador. *** " crlf crlf)
    (focus PREGUNTAS)
)

;***********************
;* MÓDULO DE PREGUNTAS *  
;***********************

(defmodule PREGUNTAS (import MAIN ?ALL) (export ?ALL))

(deftemplate User
    (slot edad (type INTEGER))
)

(defrule crear-perfil ""
    (declare (salience 100))
    =>
    (printout t "Introduzca sus datos personales." crlf)
    (bind ?edad (question "Introduzca su edad: "))
    (bind ?edad (integer ?edad))
    (if (< ?edad 0) then (printout t crlf "Edad incorrecta. " crlf)(exit))
    (assert (User (edad ?edad)))
    (printout t crlf "*** Información personal guardada correctamente. ***" crlf)
    (focus ABSTRACCION)
)

;*************************
;* MÓDULO DE ABSTRACCIÓN *  
;*************************

(defmodule ABSTRACCION (import PREGUNTAS ?ALL) (export ?ALL))

(deftemplate AbstractedUser
    (slot edad (type STRING)) ; Niño, Adolescente, Joven, Adulto, Mayor
)

(defrule abstraer-edad
    (User (edad ?edad))
    =>
    (if (< ?edad 12) then (assert (AbstractedUser (edad "niño")))
    else (if (< ?edad 20) then (assert (AbstractedUser (edad "adolescente")))
    else (if (< ?edad 35) then (assert (AbstractedUser (edad "joven")))
    else (if (< ?edad 50) then (assert (AbstractedUser (edad "adulto")))
    else (assert (AbstractedUser (edad "mayor")))))))
    (focus ASOCIACION)
)

;************************
;* MÓDULO DE ASOCIACIÓN *  
;************************

(defmodule ASOCIACION (import ABSTRACCION ?ALL) (export ?ALL))

(deftemplate AbstractedBook
    (slot genero (type STRING)) 
)

(defrule asociar-edad
    (AbstractedUser (edad ?edad))
    =>
    (if (eq ?edad "niño") then (assert (AbstractedBook (genero "Ciencia Ficción")))
    else (if (eq ?edad "adolescente") then (assert (AbstractedBook (genero "Fantasía")))
    else (if (eq ?edad "joven") then (assert (AbstractedBook (genero "Romance")))
    else (if (eq ?edad "adulto") then (assert (AbstractedBook (genero "Misterio")))
    else (assert (AbstractedBook (genero "Drama")))))))
    (focus REFINAMIENTO)
)


;**************************
;* MÓDULO DE REFINAMIENTO *  
;**************************

(defmodule REFINAMIENTO (import ASOCIACION ?ALL) (export ?ALL))

(deftemplate recomendaciones
    (multislot titulos-recomendados (type STRING))
)

; defrule usar lo q viene de la asociacion para en titulos recomendados poner libros segun sus gustos




