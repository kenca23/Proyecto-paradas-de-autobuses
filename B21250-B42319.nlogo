;;; Proyecto Paradigmas
;;; Nombre:
;;; Participantes:
;;;    Kenneth Calvo - B21250
;;;    Johan Durán   - B42319
;;; II Semestre 2016


breed[vehiculos vehiculo] ; caracterísitcas generales de los vehículos del modelo
breed[crossings crossing]
breed[personas persona]
breed[semaforos]

; Variables globales del modelo
globals[
  velocidad-general    ; velocidad global del modelo
  acelerar             ; variable para usar la aceleración del modelo
  desacelerar          ; variable para desacelerar
  tiempo-peatones      ; tiempo que esperan para cruzar
  ambulancias          ; variable para el conteo de ambulancias
  saltos-rojo-ambul    ; saltos de semáforos en rojo por parte de las ambulancias
  sem-irrespetados     ; semáforos en rojo irrespetados por conductores con bajo nivel de respeto
  sem-irrespetados-amb ; semáforos en rojo saltados por las ambulancias
]

personas-own[
  velocidad      ; velocidad de las personas
  tiempo-espera  ; tiempo
  crossing-part  ; ayuda para que el peatón cruce la calle por partes
  espera         ; peaton está en estado de espera o no
]

vehiculos-own[
  velocidad        ; Velocidad del vehículo
  maxVel           ; Velocidad maxima
  virar            ; Virar o no
  detenerse        ; Detenerse o no ante peatones a cruzar, predeterminado todos están en 3, donde se pasará a 1 (se detienen) o 2 (no se detienen)
  ser-ambulancia   ; variable para saber si un vehículo es o no ambulancia
  ser-autobus   ; variable para saber si un vehículo es o no autobus
  respeto          ; nivel de respeto de los vehículos - para ambulancias
  emergencia       ; aplica para las ambulancias, si se encuentran o no en emergencia
  rango-averia     ; probabilidad de un auto de averiarse
  averiado         ; establece si un vehículo se encuentra o no averiado
]

; Variables de los patches
patches-own[
  tipo-patch     ; tipo de patch
  estado-cruzar  ; Estado del patch por si alguien va a cruzar la calle
  cantidad-pers  ; cantidad de personas que están cruzando
  cantidad-vehic ; cantidad de vehículos cruzando
]

to setup-1
  clear-all
  set velocidad-general velocidad-carro
  set saltos-rojo-ambul 0
  set acelerar 1.5
  set desacelerar 0.1
  set tiempo-peatones 1000
  draw-sidewalk
  draw-roads
  dibujar-paradas-bus
  dibujar-paradas-personas
  draw-crossings
  poner-carros
  poner-buses
  poner-camiones
  poner-motos
  poner-semaforos
  poner-personas
  ;poner-ambulancias

  reset-ticks
  tick
end

to go-1
  mover-vehiculos
  mover-autobuses-sin-bahia
  ;mover-ambulancias
  ;cambiar-color-ambulancias
  control-semaforos
  mover-personas
  ;control-emergencias
  tick
end

to setup-2
  clear-all
  set velocidad-general velocidad-carro
  set saltos-rojo-ambul 0
  set acelerar 1.5
  set desacelerar 0.1
  set tiempo-peatones 1000
  draw-sidewalk
  draw-roads
  dibujar-paradas-bus-bahias
  dibujar-paradas-personas-bahia
  draw-crossings
  poner-carros
  poner-buses
  poner-camiones
  poner-motos
  poner-semaforos
  poner-personas
  ;poner-ambulancias

  reset-ticks
  tick
end

to go-2
  mover-vehiculos
  mover-autobuses-con-bahia
  ;mover-ambulancias
  ;cambiar-color-ambulancias
  control-semaforos
  mover-personas
  ;control-emergencias
  tick
end

;;; Método para el control de los semáforos, usamos los ticks para el cambio de color
to control-semaforos
  if ticks mod 250 = 0 [
    ask semaforos [
      ifelse color = red [
        set color green
        ]
      [
        set color red
      ]
    ]
  ]
end

;;; Dibujado de la ciudad
to dibujar-paradas-bus ;;; procedimiento para crear las paradas de autobuses en el setup 1
  ask patches with[(pycor = 18 or pycor = 40) and (pxcor mod 40 > 24 and pxcor mod 40 < 28)] [ ;para las posiciones en ese rango, cambia el tipo a parada y lo pinta con el shape parada
    set tipo-patch "parada2"
    sprout 1 [
      set shape "parada"
      set color grey
      set heading 180
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 22) and (pxcor mod 40 > 8 and pxcor mod 40 < 12)] [ ;para las posiciones en ese rango, cambia el tipo a parada y lo pinta con el shape parada
    set tipo-patch "parada2"
    sprout 1 [
      set shape "parada"
      set color grey
      set heading 0
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 18 or pycor = 40) and (pxcor mod 40 = 24 or pxcor mod 40 = 28)][ ; para esas coordenadas les pinta el inicio y final de la parada de autobuses
    set tipo-patch "parada2"
    set pcolor white
    sprout 1 [
      set shape "road-middle"
      set color grey
      set heading 90
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 22) and (pxcor mod 40 = 8 or pxcor mod 40 = 12)][ ; para esas coordenadas les pinta el inicio y final de la parada de autobuses
    set tipo-patch "parada2"
    set pcolor white
    sprout 1 [
      set shape "road-middle"
      set color grey
      set heading 90
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 18 or pycor = 40) and (pxcor mod 40 = 27)][ ; asigna el tipo de patch como parada
    set tipo-patch "parada"
  ]
  ask patches with[(pycor = 22) and (pxcor mod 40 = 9)][ ; asigna el tipo de patch como parada
    set tipo-patch "parada"
  ]
end

to dibujar-paradas-bus-bahias ;;; procedimiento para crear las paradas de autobuses en el setup 1
  ask patches with[(pycor = 17 or pycor = 39) and (pxcor mod 40 > 24 and pxcor mod 40 < 28)] [ ;para las posiciones en ese rango, cambia el tipo a parada y lo pinta con el shape parada

    sprout 1 [
      set shape "parada"
      set color grey
      set heading 180
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 23) and (pxcor mod 40 > 8 and pxcor mod 40 < 12)] [ ;para las posiciones en ese rango, cambia el tipo a parada y lo pinta con el shape parada

    sprout 1 [
      set shape "parada"
      set color grey
      set heading 0
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 18 or pycor = 40) and (pxcor mod 40 = 23 or pxcor mod 40 = 29)][ ; para esas coordenadas les pinta el inicio y final de la parada de autobuses
    set pcolor white
    sprout 1 [
      set shape "road-middle"
      set color grey
      set heading 90
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 22) and (pxcor mod 40 = 7 or pxcor mod 40 = 13)][ ; para esas coordenadas les pinta el inicio y final de la parada de autobuses
    set pcolor white
    sprout 1 [
      set shape "road-middle"
      set color grey
      set heading 90
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 17 or pycor = 39) and (pxcor mod 40 = 24)][ ; para esas coordenadas les pinta el inicio y final de la parada de autobuses
    set tipo-patch "parada2"
    set pcolor brown + 2
    sprout 1 [
      set shape "entrada-bahia"
      set color grey
      set heading 0
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 17 or pycor = 39) and (pxcor mod 40 = 28)][ ; para esas coordenadas les pinta el inicio y final de la parada de autobuses
    set tipo-patch "parada2"
    set pcolor brown + 2
    sprout 1 [
      set shape "entrada-bahia"
      set color grey
      set heading 270
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 23) and (pxcor mod 40 = 8)][ ; para esas coordenadas les pinta el inicio y final de la parada de autobuses
    set tipo-patch "parada2"
    set pcolor brown + 2
    sprout 1 [
      set shape "entrada-bahia"
      set color grey
      set heading 90
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 23) and (pxcor mod 40 = 12)][ ; para esas coordenadas les pinta el inicio y final de la parada de autobuses
    set tipo-patch "parada2"
    set pcolor brown + 2
    sprout 1 [
      set shape "entrada-bahia"
      set color grey
      set heading 180
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 17 or pycor = 39) and (pxcor mod 40 = 25 or pxcor mod 40 = 26)][ ; asigna el tipo de patch como parada
    set tipo-patch "parada"
  ]
  ask patches with[(pycor = 23) and (pxcor mod 40 = 11 or pxcor mod 40 = 10)][ ; asigna el tipo de patch como parada
    set tipo-patch "parada"
  ]
  ask patches with[(pycor = 18 or pycor = 40 or pycor = 17 or pycor = 39) and (pxcor mod 40 = 27)][ ; asigna el tipo de patch como parada
    set tipo-patch "parada1"
  ]
  ask patches with[(pycor = 22 or pycor = 23) and (pxcor mod 40 = 9)][ ; asigna el tipo de patch como parada
    set tipo-patch "parada1"
  ]


end

to dibujar-paradas-personas ; Dibuja las parada de autobuses para peatones en el setup1
  ask patches with[(pycor = 17 or pycor = 39) and (pxcor mod 40 > 24 and pxcor mod 40 < 28)] [ ;para las posiciones en ese rango, cambia el tipo a parada y lo pinta con el shape parada-peatones
    set tipo-patch "parada-peatones"
    sprout 1 [
      set shape "parada-peatones"
      set color grey
      set heading 180
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 23) and (pxcor mod 40 > 8 and pxcor mod 40 < 12)] [ ;para las posiciones en ese rango, cambia el tipo a parada y lo pinta con el shape parada-peatones
    set tipo-patch "parada-peatones"
    sprout 1 [
      set shape "parada-peatones"
      set color grey
      set heading 0
      stamp
      die
    ]
  ]
end
to dibujar-paradas-personas-bahia ; Dibuja las parada de autobuses para peatones en el setup1
  ask patches with[(pycor = 16 or pycor = 38) and (pxcor mod 40 > 24 and pxcor mod 40 < 28)] [ ;para las posiciones en ese rango, cambia el tipo a parada y lo pinta con el shape parada-peatones
    set tipo-patch "parada-peatones"
    sprout 1 [
      set shape "parada-peatones"
      set color grey
      set heading 180
      stamp
      die
    ]
  ]
  ask patches with[(pycor = 24) and (pxcor mod 40 > 8 and pxcor mod 40 < 12)] [ ;para las posiciones en ese rango, cambia el tipo a parada y lo pinta con el shape parada-peatones
    set tipo-patch "parada-peatones"
    sprout 1 [
      set shape "parada-peatones"
      set color grey
      set heading 0
      stamp
      die
    ]
  ]
end



to draw-roads
  ask patches with [(pxcor mod 40 = 39 or pxcor mod 40 = 0 or pxcor mod 40 = 36 or pxcor mod 40 = 37 or pxcor mod 40 = 38 )
    and (pycor mod 22 = 21 or pycor mod 22 = 0 or pycor mod 22 = 19 or pycor mod 22 = 18 or pycor mod 22 = 20)] [
  set pcolor grey
  set tipo-patch "crossroad"
    ]
  ask patches with [pxcor mod 40 = 39 and tipo-patch != "crossroad"] [
    set pcolor grey
    sprout 1 [
      set shape "road2"
      set color grey
      set heading 270
      stamp die
    ]
    set tipo-patch "road-up"]

  ask patches with [pxcor mod 40 = 0 and tipo-patch != "crossroad"] [
    set pcolor grey
    sprout 1 [
      set shape "road2"
      set color grey
      set heading 90
      stamp die
    ]
    set tipo-patch "road-up"]
  ask patches with [pxcor mod 40 = 36 and tipo-patch != "crossroad"] [
    set pcolor grey
    sprout 1 [
      set shape "road2"
      set color grey
      set heading 270
      stamp die
    ]
    set tipo-patch "road-down"]

  ask patches with [pxcor mod 40 = 37 and tipo-patch != "crossroad"] [
    set pcolor grey
    sprout 1 [
      set shape "road2"
      set color grey
      set heading 90
      stamp die
    ]
    set tipo-patch "road-down"]

  ;roads-right
  ask patches with [pycor mod 22 = 21 and tipo-patch != "crossroad"] [
    set pcolor grey
    sprout 1 [
      set shape "road2"
      set color grey
      set heading 180
      stamp die
    ]
    set tipo-patch "road-left"]

  ask patches with [pycor mod 22 = 0 and tipo-patch != "crossroad"] [
    set pcolor grey
    sprout 1 [
      set shape "road2"
      set color grey
      set heading 0
      stamp die
    ]
    set tipo-patch "road-left"]
  ask patches with [pycor mod 22 = 19 and tipo-patch != "crossroad"] [
    set pcolor grey
    sprout 1 [
      set shape "road2"
      set color grey
      set heading 0
      stamp die
    ]
    set tipo-patch "road-right"]

  ask patches with [pycor mod 22 = 18 and tipo-patch != "crossroad"] [
    set pcolor grey
    sprout 1 [
      set shape "road2"
      set color grey
      set heading 180
      stamp die
    ]
    set tipo-patch "road-right"]

  ask patches with [pxcor mod 40 = 38 and tipo-patch != "crossroad"] [
    set pcolor white
    sprout 1 [
      set shape "road-middle"
      set color grey
      set heading 90
      stamp
      die
    ]
    set tipo-patch "road-middle-v"
  ]
  ask patches with [pycor mod 22 = 20 and tipo-patch != "crossroad"] [
    set pcolor white
    sprout 1 [
      set shape "road-middle"
      set color grey
      set heading 0
      stamp
      die
    ]
    set tipo-patch "road-middle-h"
  ]
end

to draw-sidewalk
  ask patches with [pxcor mod 40 = 1 or pxcor mod 40 = 2 or pxcor mod 40 = 3
    or pxcor mod 40 = 35 or pxcor mod 40 = 34 or pxcor mod 40 = 33 or pycor mod 22 = 1
    or pycor mod 22 = 2 or pycor mod 22 = 3 or pycor mod 22 = 15 or pycor mod 22 = 16 or pycor mod 22 = 17] [
  set pcolor brown + 2
  sprout 1 [
    set shape "tile stones"
    set color gray +  3
    stamp
    die
  ]
  set tipo-patch "sidewalk"]
end

to draw-crossings
  ask patches with [(tipo-patch = "road-up" or tipo-patch = "road-down" or tipo-patch = "road-middle-v") and (pycor mod 22 = 2 or pycor mod 22 = 3)][
    sprout-crossings 1 [
      set shape "crossing"
      set color white
      set heading 0
      set size 1
    ]
  ]
  ;ask crossings with [pxcor mod 40 = 38] [
  ;  let newY one-of [1 -1]
  ;  ask crossings in-radius 3 with [shape = "crossing"] [
  ;    set ycor ycor + newY
  ;  ]
  ;]
  ask crossings with [pxcor mod 40 = 38] [
    set shape "waitpoint"
    set tipo-patch "waitpoint2"
    set color black + 1
    stamp die
  ]
  ask patches with [(tipo-patch = "road-left" or tipo-patch = "road-right" or tipo-patch = "road-middle-h") and (pxcor mod 40 = 33 or pxcor mod 40 = 34)][
    sprout-crossings 1 [
      set shape "crossing"
      set heading 90
      set color white
      set size 1
    ]
  ]
  ;ask crossings with [pycor mod 22 = 20] [
  ;  let newX one-of [1 2 3 4 5 -1 -2 -3 -4 -5]
  ;  ask crossings in-radius 3 with [shape = "crossing"] [
  ;    set xcor xcor + newX
  ;  ]
  ;]
  ask crossings with [pycor mod 22 = 20] [
    set heading 90
    set shape "waitpoint"
    set tipo-patch "waitpoint2"
    set color black + 1
    stamp die
  ]
  ask crossings [
    set estado-cruzar false
    set tipo-patch "crossing"
    stamp
    die
  ]
  ask patches with [tipo-patch = "crossing"] [
    ask neighbors4 [
      if tipo-patch = "sidewalk" [
        set tipo-patch "waitpoint"
        ]
      ]
    ]
end

;;; --------------------- Ubicamos los vehículos --------------
to poner-buses
    ask n-of (num-autobuses / 3) patches with [tipo-patch = "road-up"] [
    if not any? vehiculos-on patch pxcor (pycor + 1) and not any? vehiculos-here and not any? vehiculos-on patch pxcor (pycor - 1) and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set size 3
        set virar 3
        set detenerse 3
        set shape "bus"
        set ser-ambulancia false
        set ser-autobus true
        set color one-of base-colors
        set heading 0
        let vel random 10
        if vel < 7 [set maxVel velocidad-autobuses - 15 + random 16]
        if vel = 7 [set maxVel velocidad-autobuses - 20 + random 6]
        if vel > 7 [set maxVel velocidad-autobuses + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  ask n-of (num-autobuses / 3) patches with [tipo-patch = "road-down" and count turtles-on neighbors = 0] [
    if not any? vehiculos-on patch pxcor (pycor + 1) and not any? vehiculos-here and not any? vehiculos-on patch pxcor (pycor - 1) and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set size 3
        set shape "bus"
        set ser-ambulancia false
        set ser-autobus true
        set color one-of base-colors
        set heading 180
        set virar 3
        set detenerse 3
        let vel random 10
        if vel < 7 [set maxVel velocidad-autobuses - 15 + random 16]
        if vel = 7 [set maxVel velocidad-autobuses - 20 + random 6]
        if vel > 7 [set maxVel velocidad-autobuses + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  ask n-of (num-autobuses / 3) patches with [tipo-patch = "road-left" and count turtles-on neighbors = 0] [
    if not any? vehiculos-on patch (pxcor + 1) pycor and not any? vehiculos-here and not any? vehiculos-on patch (pxcor - 1) pycor and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set virar 3
        set detenerse 3
        set size 3
        set shape "bus"
        set ser-ambulancia false
        set ser-autobus true
        set color one-of base-colors
        set heading 270
        let vel random 10
        if vel < 7 [set maxVel velocidad-autobuses - 15 + random 16]
        if vel = 7 [set maxVel velocidad-autobuses - 20 + random 6]
        if vel > 7 [set maxVel velocidad-autobuses + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  while [count vehiculos < num-autobuses] [
    ask one-of patches with [tipo-patch = "road-right"] [
      if not any? vehiculos-on patch (pxcor + 1) pycor and not any? vehiculos-here and not any? vehiculos-on patch (pxcor - 1) pycor and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
        sprout-vehiculos 1 [
          set virar 3
          set detenerse 3
          set size 3
          set shape "bus"
          set ser-ambulancia false
          set ser-autobus true
          set color one-of base-colors
          set heading 90
          let vel random 10
          if vel < 7 [set maxVel velocidad-autobuses - 15 + random 16]
          if vel = 7 [set maxVel velocidad-autobuses - 20 + random 6]
          if vel > 7 [set maxVel velocidad-autobuses + random 16]
          set velocidad maxVel - random 20
          set respeto random 100
          set emergencia false
          set rango-averia random 100
        ]
      ]
    ]
  ]
end



to poner-carros
  ask n-of (num-carros / 3) patches with [tipo-patch = "road-up"] [
    if not any? vehiculos-on patch pxcor (pycor + 1) and not any? vehiculos-here and not any? vehiculos-on patch pxcor (pycor - 1) and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set size 2
        set virar 3
        set detenerse 3
        set shape "car top"
        set ser-ambulancia false
        set ser-autobus false
        set color one-of base-colors
        set heading 0
        let vel random 10
        if vel < 7 [set maxVel velocidad-carro - 15 + random 16]
        if vel = 7 [set maxVel velocidad-carro - 20 + random 6]
        if vel > 7 [set maxVel velocidad-carro + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  ask n-of (num-carros / 3) patches with [tipo-patch = "road-down" and count turtles-on neighbors = 0] [
    if not any? vehiculos-on patch pxcor (pycor + 1) and not any? vehiculos-here and not any? vehiculos-on patch pxcor (pycor - 1) and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set size 2
        set shape "car top"
        set ser-ambulancia false
        set ser-autobus false
        set color one-of base-colors
        set heading 180
        set virar 3
        set detenerse 3
        let vel random 10
        if vel < 7 [set maxVel velocidad-carro - 15 + random 16]
        if vel = 7 [set maxVel velocidad-carro - 20 + random 6]
        if vel > 7 [set maxVel velocidad-carro + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  ask n-of (num-carros / 3) patches with [tipo-patch = "road-left" and count turtles-on neighbors = 0] [
    if not any? vehiculos-on patch (pxcor + 1) pycor and not any? vehiculos-here and not any? vehiculos-on patch (pxcor - 1) pycor and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set virar 3
        set detenerse 3
        set size 2
        set shape "car top"
        set ser-ambulancia false
        set ser-autobus false
        set color one-of base-colors
        set heading 270
        let vel random 10
        if vel < 7 [set maxVel velocidad-carro - 15 + random 16]
        if vel = 7 [set maxVel velocidad-carro - 20 + random 6]
        if vel > 7 [set maxVel velocidad-carro + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  while [count vehiculos < num-carros] [
    ask one-of patches with [tipo-patch = "road-right"] [
      if not any? vehiculos-on patch (pxcor + 1) pycor and not any? vehiculos-here and not any? vehiculos-on patch (pxcor - 1) pycor and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
        sprout-vehiculos 1 [
          set virar 3
          set detenerse 3
          set size 2
          set shape "car top"
          set ser-ambulancia false
          set ser-autobus false
          set color one-of base-colors
          set heading 90
          let vel random 10
          if vel < 7 [set maxVel velocidad-carro - 15 + random 16]
          if vel = 7 [set maxVel velocidad-carro - 20 + random 6]
          if vel > 7 [set maxVel velocidad-carro + random 16]
          set velocidad maxVel - random 20
          set respeto random 100
          set emergencia false
          set rango-averia random 100
        ]
      ]
    ]
  ]
end

to poner-ambulancias
set ambulancias num-ambulancias
while [ ambulancias > 0] [
    ask one-of patches with [tipo-patch = "road-right"] [
      if not any? vehiculos-on patch (pxcor + 1) pycor and not any? vehiculos-here and not any? vehiculos-on patch (pxcor - 1) pycor and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
        sprout-vehiculos 1 [
          set virar 3
          set detenerse 3
          set size 2
          set shape "ambulance"
          set ser-ambulancia true
          set ser-autobus false
          set color red
          set heading 90
          let vel random 10
          set maxVel velocidad-ambulancias
          set velocidad maxVel - random 20
          set respeto 0
          set emergencia true
          set rango-averia 0
        ]
      ]
    ]
    set ambulancias ambulancias - 1
  ]
end

to poner-camiones
  ask n-of (num-camiones / 3) patches with [tipo-patch = "road-up"] [
    if not any? vehiculos-on patch pxcor (pycor + 1) and not any? vehiculos-here and not any? vehiculos-on patch pxcor (pycor - 1) and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set size 2
        set virar 3
        set detenerse 3
        set shape "truck cab top"
        set ser-ambulancia false
        set ser-autobus false
        set heading 0
        set color one-of base-colors
        let vel random 10
        if vel < 7 [set maxVel velocidad-camion - 15 + random 16]
        if vel = 7 [set maxVel velocidad-camion - 20 + random 6]
        if vel > 7 [set maxVel velocidad-camion + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  ask n-of (num-camiones / 3) patches with [tipo-patch = "road-down" and count turtles-on neighbors = 0] [
    if not any? vehiculos-on patch pxcor (pycor + 1) and not any? vehiculos-here and not any? vehiculos-on patch pxcor (pycor - 1) and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set size 2
        set shape "truck cab top"
        set heading 180
        set color one-of base-colors
        set ser-ambulancia false
        set ser-autobus false
        set virar 3
        set detenerse 3
        let vel random 10
        if vel < 7 [set maxVel velocidad-camion - 15 + random 16]
        if vel = 7 [set maxVel velocidad-camion - 20 + random 6]
        if vel > 7 [set maxVel velocidad-camion + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  ask n-of (num-camiones / 3) patches with [tipo-patch = "road-left" and count turtles-on neighbors = 0] [
    if not any? vehiculos-on patch (pxcor + 1) pycor and not any? vehiculos-here and not any? vehiculos-on patch (pxcor - 1) pycor and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set virar 3
        set detenerse 3
        set size 2
        set shape "truck cab top"
        set color one-of base-colors
        set ser-ambulancia false
        set ser-autobus false
        set heading 270
        let vel random 10
        if vel < 7 [set maxVel velocidad-camion - 15 + random 16]
        if vel = 7 [set maxVel velocidad-camion - 20 + random 6]
        if vel > 7 [set maxVel velocidad-camion + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  while [count vehiculos < num-camiones] [
    ask one-of patches with [tipo-patch = "road-right"] [
      if not any? vehiculos-on patch (pxcor + 1) pycor and not any? vehiculos-here and not any? vehiculos-on patch (pxcor - 1) pycor and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
        sprout-vehiculos 1 [
          set virar 3
          set detenerse 3
          set size 2
          set shape "truck cab top"
          set ser-ambulancia false
          set ser-autobus false
          set heading 90
          let vel random 10
          if vel < 7 [set maxVel velocidad-camion - 15 + random 16]
          if vel = 7 [set maxVel velocidad-camion - 20 + random 6]
          if vel > 7 [set maxVel velocidad-camion + random 16]
          set velocidad maxVel - random 20
          set respeto random 100
          set emergencia false
          set rango-averia random 100
        ]
      ]
    ]
  ]
end

to poner-motos
  ask n-of (num-motos / 3) patches with [tipo-patch = "road-up"] [
    if not any? vehiculos-on patch pxcor (pycor + 1) and not any? vehiculos-here and not any? vehiculos-on patch pxcor (pycor - 1) and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set size 1
        set virar 3
        set detenerse 3
        set shape "bike top"
        set ser-ambulancia false
        set ser-autobus false
        set heading 0
        set color one-of base-colors
        let vel random 10
        if vel < 7 [set maxVel velocidad-moto - 15 + random 16]
        if vel = 7 [set maxVel velocidad-moto - 20 + random 6]
        if vel > 7 [set maxVel velocidad-moto + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  ask n-of (num-motos / 3) patches with [tipo-patch = "road-down" and count turtles-on neighbors = 0] [
    if not any? vehiculos-on patch pxcor (pycor + 1) and not any? vehiculos-here and not any? vehiculos-on patch pxcor (pycor - 1) and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set size 1
        set shape "bike top"
        set heading 180
        set color one-of base-colors
        set ser-ambulancia false
        set ser-autobus false
        set virar 3
        set detenerse 3
        let vel random 10
        if vel < 7 [set maxVel velocidad-moto - 15 + random 16]
        if vel = 7 [set maxVel velocidad-moto - 20 + random 6]
        if vel > 7 [set maxVel velocidad-moto + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  ask n-of (num-motos / 3) patches with [tipo-patch = "road-left" and count turtles-on neighbors = 0] [
    if not any? vehiculos-on patch (pxcor + 1) pycor and not any? vehiculos-here and not any? vehiculos-on patch (pxcor - 1) pycor and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
      sprout-vehiculos 1 [
        set virar 3
        set detenerse 3
        set size 1
        set shape "bike top"
        set ser-ambulancia false
        set ser-autobus false
        set heading 270
        set color one-of base-colors
        let vel random 10
        if vel < 7 [set maxVel velocidad-moto - 15 + random 16]
        if vel = 7 [set maxVel velocidad-moto - 20 + random 6]
        if vel > 7 [set maxVel velocidad-moto + random 16]
        set velocidad maxVel - random 20
        set respeto random 100
        set emergencia false
        set rango-averia random 100
      ]
    ]
  ]

  while [count vehiculos < num-motos] [
    ask one-of patches with [tipo-patch = "road-right"] [
      if not any? vehiculos-on patch (pxcor + 1) pycor and not any? vehiculos-here and not any? vehiculos-on patch (pxcor - 1) pycor and not any? patches with [tipo-patch = "crossing"] in-radius 2 [
        sprout-vehiculos 1 [
          set virar 3
          set detenerse 3
          set size 1
          set shape "bike top"
          set ser-ambulancia false
          set ser-autobus false
          set heading 90
          set color one-of base-colors
          let vel random 10
          if vel < 7 [set maxVel velocidad-moto - 15 + random 16]
          if vel = 7 [set maxVel velocidad-moto - 20 + random 6]
          if vel > 7 [set maxVel velocidad-moto + random 16]
          set velocidad maxVel - random 20
          set respeto random 100
          set emergencia false
          set rango-averia random 100
        ]
      ]
    ]
  ]
end

to poner-personas
  while [count personas < num-personas] [
    ask one-of patches with [tipo-patch = "sidewalk"] [
      sprout-personas 1 [
        set velocidad 35
        set size 1
        set espera false
        set tiempo-espera random tiempo-peatones
        set shape one-of ["person business" "person construction" "person doctor"
          "person farmer" "person graduate" "person lumberjack" "person police" "person service"
          "person student" "person soldier"
        ]
      ]
    ]
  ]
end

to poner-semaforos
  ask patches with [(pycor mod 22 = 0 or pycor mod 22 = 21) and pxcor mod 40 = 1] [
    sprout-semaforos 1 [
      set color red
      set shape "lights"
    ]
  ]

  ask patches with [(pycor mod 22 = 19 or pycor mod 22 = 18) and pxcor mod 40 = 35] [
    sprout-semaforos 1 [
      set color red
      set shape "lights"
    ]
  ]

  ask patches with [(pxcor mod 40 = 36 or pxcor mod 40 = 37) and pycor mod 22 = 1] [
    sprout-semaforos 1 [
      set color green
      set shape "lights"
    ]
  ]

  ask patches with [(pxcor mod 40 = 39 or pxcor mod 40 = 0) and pycor mod 22 = 17] [
    sprout-semaforos 1 [
      set color green
      set shape "lights"
    ]
  ]
end

to control-velocidad
  let car-ahead one-of vehiculos-on patch-ahead 2.5
;  if car-ahead != nobody [
;    ifelse ([ser-autobus] of car-ahead = true) [
;      set car-ahead one-of vehiculos-on patch-ahead 2.5
;    ]
;    [
;      set car-ahead one-of vehiculos-on patch-ahead 1.5
;    ]
;  ]


  ifelse car-ahead = nobody  [
    ifelse velocidad < maxVel [set velocidad velocidad + acelerar] [set velocidad velocidad - desacelerar]
  ]
  [
    ifelse [velocidad] of car-ahead = 0 [
      set velocidad 0
    ]
    [
      ifelse [velocidad] of car-ahead >= maxVel [
        set velocidad maxVel
        set velocidad velocidad - desacelerar
      ]
      [
      ;;; adelantamiento
        ifelse [tipo-patch] of patch-left-and-ahead 90 1 = tipo-patch and
        [tipo-patch] of patch-left-and-ahead 90 1 != "parada" and
          [tipo-patch] of patch-left-and-ahead 90 1 != "parada1" and
          [tipo-patch] of patch-left-and-ahead 90 1 != "parada2" and
        not any? vehiculos-on patch-left-and-ahead 90 1 and
        [tipo-patch] of patch-left-and-ahead 90 1 != "crossroad" and
        tipo-patch != "crossing" and
        [tipo-patch] of patch-left-and-ahead 180 1.3 != "crossing" and
        not any? vehiculos-on patch-left-and-ahead 169 3 and
        not any? vehiculos-on patch-left-and-ahead 45 1 and
        not any? vehiculos-on patch-left-and-ahead 135 1 and
        not any? vehiculos-on patch-left-and-ahead 23 2 and
        not any? vehiculos-on patch-left-and-ahead 157 2 and
        not any? vehiculos-on patch-left-and-ahead 12 3 and
        [tipo-patch] of patch-ahead 1 != "crossing" [
          move-to patch-left-and-ahead 90 1
        ]
        [
          ifelse [tipo-patch] of patch-right-and-ahead 90 1 = tipo-patch and
          [tipo-patch] of patch-right-and-ahead 90 1 != "parada" and
          [tipo-patch] of patch-right-and-ahead 90 1 != "parada1" and
          [tipo-patch] of patch-right-and-ahead 90 1 != "parada2" and
          not any? vehiculos-on patch-right-and-ahead 90 14 and
          [tipo-patch] of patch-right-and-ahead 90 1 != "crossroad" and
          tipo-patch != "crossing" and
          [tipo-patch] of patch-right-and-ahead 180 1.3 != "crossing" and
          not any? vehiculos-on patch-right-and-ahead 12 3 and
          not any? vehiculos-on patch-right-and-ahead 45 1 and
          not any? vehiculos-on patch-right-and-ahead 135 1 and
          not any? vehiculos-on patch-right-and-ahead 23 2 and
          not any? vehiculos-on patch-right-and-ahead 157 2 and
          not any? vehiculos-on patch-right-and-ahead 169 3 and
          [tipo-patch] of patch-ahead 1 != "crossing"[
            move-to patch-right-and-ahead 90 1
          ]
          [
            set velocidad [velocidad] of car-ahead
            set velocidad velocidad - desacelerar
          ]
        ]
      ]
    ]
  ]
end

to control-autobus-sin-bahia
  let car-ahead one-of vehiculos-on patch-ahead 2.5
;  if car-ahead != nobody [
;    ifelse ([ser-autobus] of car-ahead = true) [
;      set car-ahead one-of vehiculos-on patch-ahead 2.5
;    ]
;    [
;      set car-ahead one-of vehiculos-on patch-ahead 1.5
;    ]
;  ]
  ifelse ([tipo-patch] of patch-ahead 1 = "parada") and (ticks mod 100 != 0 or ticks mod 100 != 1 or ticks mod 100 != 2)[ ; se el siguiente campo es la parada y los ticks no son modulo 100 = 0 ó 1 ó 2 entonces se detiene a recoger personas
    set velocidad 0
  ]
  [ ; sino
    if car-ahead = nobody[  ; si no hay autos delante entonces acelera.
      set velocidad velocidad + acelerar
    ]
  ]


   ifelse car-ahead = nobody  [
     ifelse velocidad < maxVel [set velocidad velocidad + acelerar] [set velocidad velocidad - desacelerar]
   ]
   [
     ifelse [velocidad] of car-ahead = 0 [
       set velocidad 0
     ]
     [
       ifelse [velocidad] of car-ahead >= maxVel [
         set velocidad maxVel
         set velocidad velocidad - desacelerar
       ]
       [
         ;;; adelantamiento
         ifelse [tipo-patch] of patch-left-and-ahead 90 1 = tipo-patch and
         not any? vehiculos-on patch-left-and-ahead 90 1 and
         [tipo-patch] of patch-left-and-ahead 90 1 != "crossroad" and
         tipo-patch != "crossing" and
         [tipo-patch] of patch-left-and-ahead 180 1.3 != "crossing" and
         not any? vehiculos-on patch-left-and-ahead 169 3 and
         not any? vehiculos-on patch-left-and-ahead 45 1 and
         not any? vehiculos-on patch-left-and-ahead 135 1 and
         not any? vehiculos-on patch-left-and-ahead 23 2 and
         not any? vehiculos-on patch-left-and-ahead 157 2 and
         not any? vehiculos-on patch-left-and-ahead 12 3 and
         [tipo-patch] of patch-ahead 1 != "crossing" [
           move-to patch-left-and-ahead 90 1
         ]
         [
           ifelse [tipo-patch] of patch-right-and-ahead 90 1 = tipo-patch and
           not any? vehiculos-on patch-right-and-ahead 90 14 and
           [tipo-patch] of patch-right-and-ahead 90 1 != "crossroad" and
           tipo-patch != "crossing" and
           [tipo-patch] of patch-right-and-ahead 180 1.3 != "crossing" and
           not any? vehiculos-on patch-right-and-ahead 12 3 and
           not any? vehiculos-on patch-right-and-ahead 45 1 and
           not any? vehiculos-on patch-right-and-ahead 135 1 and
           not any? vehiculos-on patch-right-and-ahead 23 2 and
           not any? vehiculos-on patch-right-and-ahead 157 2 and
           not any? vehiculos-on patch-right-and-ahead 169 3 and
           [tipo-patch] of patch-ahead 1 != "crossing"[
             move-to patch-right-and-ahead 90 1
           ]
           [
             set velocidad [velocidad] of car-ahead
             set velocidad velocidad - desacelerar
           ]
         ]
       ]


    ]
  ]
end

to control-autobus-con-bahia
  let car-ahead one-of vehiculos-on patch-ahead 2.5
;  if car-ahead != nobody [
;    ifelse ([ser-autobus] of car-ahead = true) [
;      set car-ahead one-of vehiculos-on patch-ahead 2.5
;    ]
;    [
;      set car-ahead one-of vehiculos-on patch-ahead 1.5
;    ]
;  ]
let bus-ahead one-of vehiculos-on patch-right-and-ahead 90 1
  ifelse (([tipo-patch] of patch-right-and-ahead 90 1 = "parada") and (bus-ahead = nobody))[
    ;user-message (word "entro a doblar")
    move-to patch-right-and-ahead 90 1
  ]
  [
    ifelse ([tipo-patch] of patch-ahead 1 = "parada")[
      ifelse (ticks mod 300 < 290 and ticks mod 300 > 2)[ ; se el siguiente campo es la parada y los ticks no son modulo 100 = 0 ó 1 ó 2 entonces se detiene a recoger personas
        ;move-to patch-ahead 1
        set velocidad 0
        ;user-message (word "espero")
      ]
      [
        set velocidad velocidad + (2 * acelerar)
      ]
    ]
   [
     let bus-ahead1 one-of vehiculos-on patch-left-and-ahead 90 1
     ifelse (([tipo-patch] of patch-left-and-ahead 90 1 = "parada1")and (bus-ahead1 = nobody))[
       move-to patch-left-and-ahead 90 1
       set velocidad velocidad + acelerar
       ;user-message (word "salgo")
     ]
     [
       ifelse ([tipo-patch] of patch-ahead 1  = "parada2" or [tipo-patch] of patch-ahead 1 = "sidewalk" )[
         set velocidad 0
         ;user-message (word "Tengo que esperar")
       ]
       [
         ifelse car-ahead = nobody  [
           ifelse velocidad < maxVel [set velocidad velocidad + acelerar] [set velocidad velocidad - desacelerar]
         ]
         [
           ifelse [velocidad] of car-ahead = 0 [
             set velocidad 0
           ]
           [
             ifelse [velocidad] of car-ahead >= maxVel [
               set velocidad maxVel
               set velocidad velocidad - desacelerar
             ]
             [
               ;;; adelantamiento
               ifelse [tipo-patch] of patch-left-and-ahead 90 1 = tipo-patch and
               not any? vehiculos-on patch-left-and-ahead 90 1 and
               [tipo-patch] of patch-left-and-ahead 90 1 != "crossroad" and
               tipo-patch != "crossing" and
               [tipo-patch] of patch-left-and-ahead 180 1.3 != "crossing" and
               not any? vehiculos-on patch-left-and-ahead 169 3 and
               not any? vehiculos-on patch-left-and-ahead 45 1 and
               not any? vehiculos-on patch-left-and-ahead 135 1 and
               not any? vehiculos-on patch-left-and-ahead 23 2 and
               not any? vehiculos-on patch-left-and-ahead 157 2 and
               not any? vehiculos-on patch-left-and-ahead 12 3 and
               [tipo-patch] of patch-ahead 1 != "crossing" [
                 move-to patch-left-and-ahead 90 1
               ]
               [
                 ifelse [tipo-patch] of patch-right-and-ahead 90 1 = tipo-patch and
                 not any? vehiculos-on patch-right-and-ahead 90 14 and
                 [tipo-patch] of patch-right-and-ahead 90 1 != "crossroad" and
                 tipo-patch != "crossing" and
                 [tipo-patch] of patch-right-and-ahead 180 1.3 != "crossing" and
                 not any? vehiculos-on patch-right-and-ahead 12 3 and
                 not any? vehiculos-on patch-right-and-ahead 45 1 and
                 not any? vehiculos-on patch-right-and-ahead 135 1 and
                 not any? vehiculos-on patch-right-and-ahead 23 2 and
                 not any? vehiculos-on patch-right-and-ahead 157 2 and
                 not any? vehiculos-on patch-right-and-ahead 169 3 and
                 [tipo-patch] of patch-ahead 1 != "crossing"[
                   move-to patch-right-and-ahead 90 1
                 ]
                 [
                   set velocidad [velocidad] of car-ahead
                   set velocidad velocidad - desacelerar
                 ]
               ]
             ]
           ]
         ]
       ]



      ; set velocidad 0
     ]




     ; set velocidad velocidad + acelerar
   ]


    ; set velocidad velocidad + acelerar
  ]




end



to-report virar-derecha
  if pxcor mod 40 = 0 and pycor mod 22 = 18 and heading = 0 [report true]
  if pxcor mod 40 = 36 and pycor mod 22 = 0 and heading = 180 [report true]
  if pxcor mod 40 = 36 and pycor mod 22 = 18 and heading = 90 [report true]
  if pxcor mod 40 = 0 and pycor mod 22 = 0 and heading = 270 [report true]
  report false
end

to mover-vehiculos
  ask vehiculos [
    if (ser-ambulancia = false and ser-autobus = false) [
    control-velocidad
    if virar = 3 [
      if virar-derecha [
        ifelse random 100 < 40 [
          set virar 1
          move-to patch-ahead 0 rt 35
        ]
        [set virar 2]
      ]
    ]

    if virar = 1 [
      ifelse not any? vehiculos-on patch-right-and-ahead 55 1 [
        if velocidad < 15 [
          set velocidad 15
        ]
        rt 55
        set virar 2
      ]
      [
        set velocidad 0
      ]
    ]

    if tipo-patch = "crossing" [
      set virar 3
    ]

    if respeto >= 10 [
      checkear-peatones
    ]
    ;checkear-peatones
      ifelse not any? (semaforos-on patch-ahead 1.5) with [color = red] and not any? (semaforos-on patch-ahead 1.5) with [color = red]
      and not any? (semaforos-on patch-ahead 1.5) with [color = red] and not any? (semaforos-on patch-ahead 1.5) with [color = red] [fd velocidad / 200 ] [
        ifelse respeto >= 10 [
          set velocidad 0
        ] [
          set sem-irrespetados sem-irrespetados + 1
          fd velocidad / 200
        ]
       ]
    ]
  ]
end

to mover-autobuses-sin-bahia
  ask vehiculos [
    if (ser-autobus = true) [
    control-autobus-sin-bahia
    if virar = 3 [
      if virar-derecha [
        ifelse random 100 < 40 [
          set virar 1
          move-to patch-ahead 0 rt 35
        ]
        [set virar 2]
      ]
    ]

    if virar = 1 [
      ifelse not any? vehiculos-on patch-right-and-ahead 55 1 [
        if velocidad < 15 [
          set velocidad 15
        ]
        rt 55
        set virar 2
      ]
      [
        set velocidad 0
      ]
    ]

    if tipo-patch = "crossing" [
      set virar 3
    ]

    if respeto >= 10 [
      checkear-peatones
    ]
    ;checkear-peatones
      ifelse not any? (semaforos-on patch-ahead 1.5) with [color = red] and not any? (semaforos-on patch-ahead 1.5) with [color = red]
      and not any? (semaforos-on patch-ahead 1.5) with [color = red] and not any? (semaforos-on patch-ahead 1.5) with [color = red] [fd velocidad / 200 ] [
        ifelse respeto >= 10 [
          set velocidad 0
        ] [
          set sem-irrespetados sem-irrespetados + 1
          fd velocidad / 200
        ]
       ]
    ]
  ]
end

to mover-autobuses-con-bahia
  ask vehiculos [
    if (ser-autobus = true) [
    control-autobus-con-bahia
    if virar = 3 [
      if virar-derecha [
        ifelse random 100 < 40 [
          set virar 1
          move-to patch-ahead 0 rt 35
        ]
        [set virar 2]
      ]
    ]

    if virar = 1 [
      ifelse not any? vehiculos-on patch-right-and-ahead 55 1 [
        if velocidad < 15 [
          set velocidad 15
        ]
        rt 55
        set virar 2
      ]
      [
        set velocidad 0
      ]
    ]

    if tipo-patch = "crossing" [
      set virar 3
    ]

    if respeto >= 10 [
      checkear-peatones
    ]
    ;checkear-peatones
      ifelse not any? (semaforos-on patch-ahead 1.5) with [color = red] and not any? (semaforos-on patch-ahead 1.5) with [color = red]
      and not any? (semaforos-on patch-ahead 1.5) with [color = red] and not any? (semaforos-on patch-ahead 1.5) with [color = red] [fd velocidad / 200 ] [
        ifelse respeto >= 10 [
          set velocidad 0
        ] [
          set sem-irrespetados sem-irrespetados + 1
          fd velocidad / 200
        ]
       ]
    ]
  ]
end

to mover-ambulancias
  ask vehiculos [
    if ser-ambulancia = true [
    control-velocidad
    if virar = 3 [
      if virar-derecha [
        ifelse random 100 < 40 [
          set virar 1
          move-to patch-ahead 0 rt 35
        ]
        [set virar 2]
      ]
    ]
    if virar = 1 [
      ifelse not any? vehiculos-on patch-right-and-ahead 55 1 [
        if velocidad < 15 [
          set velocidad 15
        ]
        rt 55
        set virar 2
      ]
      [
        set velocidad 20
      ]
    ]

    if tipo-patch = "crossing" [
      set virar 3
    ]
        ifelse not any? (semaforos-on patch-ahead 1.5) with [color = red] and not any? (semaforos-on patch-ahead 1.5) with [color = red]
        and not any? (semaforos-on patch-ahead 1.5) with [color = red] and not any? (semaforos-on patch-ahead 1.5) with [color = red]
        [
          fd velocidad / 100
          ]
        [
          ifelse respeto >= 25 [
          set velocidad 0
        ] [
          set sem-irrespetados-amb sem-irrespetados-amb + 1
          fd velocidad / 100
        ]
       ]
      ]
    ]
end

to cambiar-color-ambulancias
  if ticks mod 10 = 0 [
    ask vehiculos[
      if ser-ambulancia = true and emergencia = true[
        ifelse color = red [set color blue] [set color red]
      ]
    ]
  ]
end

to control-emergencias
  if ticks mod 350 = 0 [
    ask vehiculos[
      if ser-ambulancia = true [
        ifelse emergencia = true [
          if random 100 > 50 [
            set emergencia false
            ;set velocidad velocidad - 80
            ;set velocidad velocidad - random 50
            set maxVel maxVel - 80
            set maxVel maxVel - random 30
            set color red
            set respeto 100
          ]
        ]
        [
          if random 100 > 50 [
            set emergencia true
            set maxVel velocidad-ambulancias
            ;set velocidad maxVel
            set respeto 0
          ]
        ]

      ]
    ]
  ]
end

to chequear-ambulancias-emerg
  ask vehiculos [
    let my-heading heading
    if [tipo-patch] of patch-here = "road-right" [
      ask vehiculos-on patch-at-heading-and-distance ([heading] of vehiculos) -1 [
        if ser-ambulancia = true and emergencia = true [
        ifelse [tipo-patch] of patch-left-and-ahead 90 1 = tipo-patch and not any? turtles-on patch-left-and-ahead 90 1 and [tipo-patch] of patch-left-and-ahead 90 1 != "crossroad"
        and tipo-patch != "crossing" and [tipo-patch] of patch-left-and-ahead 180 1.3 != "crossing" and not any? turtles-on patch-left-and-ahead 169 3
        and not any? turtles-on patch-left-and-ahead 45 1 and not any? turtles-on patch-left-and-ahead 135 1 and not any? turtles-on patch-left-and-ahead 23 2
        and not any? turtles-on patch-left-and-ahead 157 2 and not any? turtles-on patch-left-and-ahead 12 3 and [tipo-patch] of patch-ahead 1 != "crossing" [move-to patch-left-and-ahead 90 1]
        [
          ifelse [tipo-patch] of patch-right-and-ahead 90 1 = tipo-patch and not any? turtles-on patch-right-and-ahead 90 14 and [tipo-patch] of patch-right-and-ahead 90 1 != "crossroad"
          and tipo-patch != "crossing" and [tipo-patch] of patch-right-and-ahead 180 1.3 != "crossing" and not any? turtles-on patch-right-and-ahead 12 3
          and not any? turtles-on patch-right-and-ahead 45 1 and not any? turtles-on patch-right-and-ahead 135 1 and not any? turtles-on patch-right-and-ahead 23 2
          and not any? turtles-on patch-right-and-ahead 157 2 and not any? turtles-on patch-right-and-ahead 169 3 and [tipo-patch] of patch-ahead 1 != "crossing"[move-to patch-right-and-ahead 90 1] [
            set velocidad [velocidad] of vehiculos-on patch-at-heading-and-distance ([heading] of myself) -1
            set velocidad velocidad - desacelerar]
        ]

       ]
      ]
    ]
  ]
end

to control-averias
  if ticks mod 400 = 0 [
    ask vehiculos[
      if ser-ambulancia = false [
          if rango-averia > 85 [
            ifelse random 100 > 88 [
              set averiado true
              set shape "x"
              if maxVel = velocidad-carro [
                set maxVel maxVel - 70
                ;set maxVel maxVel - random 10
              ]
              if maxVel = velocidad-moto [
                set maxVel maxVel - 95
                ;set maxVel maxVel - random 10
              ]
              if maxVel = velocidad-camion [
                set maxVel maxVel - 32
                ;set maxVel maxVel - random 5
              ]
            ] [
              set averiado false
            ]

          ]
      ]
    ]
  ]
end

to checkear-peatones
  if [tipo-patch] of patch-ahead 1 = "crossing" and detenerse = 3[
    if [cantidad-pers] of patch-ahead 1 = 0 and detenerse = 3[
      set detenerse 2
      ask patch-ahead 1 [
        set cantidad-vehic cantidad-vehic + 1
        ask other neighbors with [tipo-patch = "crossing"] [set cantidad-vehic cantidad-vehic + 1]
      ]
    ]
    if [cantidad-pers] of patch-ahead 1 > 0 and detenerse = 3[
      ifelse random 100 < 70 [
        set detenerse 1
        set velocidad 0
      ]
      [
        set detenerse 2
        ask patch-ahead 1 [
          set cantidad-vehic cantidad-vehic + 1
          ask other neighbors with [tipo-patch = "crossing"] [set cantidad-vehic cantidad-vehic + 1]
        ]
        if any? personas-on patch-ahead 1 or any? personas-on patch-ahead 2 [set velocidad 0]
      ]
    ]
  ]

  if [tipo-patch] of patch-ahead 1 = "crossing" and [tipo-patch] of patch-ahead 2 = "crossing" and detenerse = 1 and [cantidad-pers] of patch-ahead 1 > 0 [set velocidad 0]

  if [tipo-patch] of patch-left-and-ahead 180 1 = "crossing" and [tipo-patch] of patch-left-and-ahead 180 2 = "crossing" and detenerse = 2 and tipo-patch != "crossing" [
    set detenerse 3
    ask patch-left-and-ahead 180 1 [
      set cantidad-vehic cantidad-vehic - 1
      ask other neighbors with [tipo-patch = "crossing"] [set cantidad-vehic cantidad-vehic - 1]
    ]
  ]

  if tipo-patch = "crossroad" and detenerse != 3 [
    set detenerse 3
  ]
end

;;; Personas ----- movimiento de los peatones
to mover-personas
  ask personas [
    ifelse tiempo-espera >= tiempo-peatones [
      if crossing-part >= 1[
        cross-the-street
        stop
      ]
      if tipo-patch = "waitpoint" [
        set crossing-part 1
      ]
      face min-one-of patches with [tipo-patch = "waitpoint"] [distance myself]
      walk
    ]
    [walk]
  ]

end

to walk
  ifelse tipo-patch = "parada-peatones"[
    set heading 0
    let bus-ahead one-of vehiculos-on patch-ahead 1
    let bus-ahead2 one-of vehiculos-on patch-at-heading-and-distance 180 1
    if (bus-ahead != nobody)[
      if ([ser-autobus] of bus-ahead = true)[
        die
        ask one-of patches with [tipo-patch = "sidewalk"] [
          sprout-personas 1 [
            set velocidad 35
            set size 1
            set espera false
            set tiempo-espera random tiempo-peatones
            set shape one-of ["person business" "person construction" "person doctor"
              "person farmer" "person graduate" "person lumberjack" "person police" "person service"
              "person student" "person soldier"
            ]
          ]
        ]
      ]
    ]
    if (bus-ahead2 != nobody)[
      if ([ser-autobus] of bus-ahead2 = true)[
        die
        ask one-of patches with [tipo-patch = "sidewalk"] [
          sprout-personas 1 [
            set velocidad 35
            set size 1
            set espera false
            set tiempo-espera random tiempo-peatones
            set shape one-of ["person business" "person construction" "person doctor"
              "person farmer" "person graduate" "person lumberjack" "person police" "person service"
              "person student" "person soldier"
            ]
          ]
        ]
      ]
    ]
  ]
  [
    ifelse [tipo-patch] of patch-ahead 1 = "sidewalk" or [tipo-patch] of patch-ahead 1 = "waitpoint" or [tipo-patch] of patch-ahead 1 = "parada-peatones" [
      ifelse any? other personas-on patch-ahead 1 [
        rt random 45
        lt  random 45
        set tiempo-espera tiempo-espera + 1
      ]
      [fd velocidad / 200 set tiempo-espera tiempo-espera + 1]
    ]
    [
      rt random 120
      lt random 120
      if [tipo-patch] of patch-ahead 1 = "sidewalk" or [tipo-patch] of patch-ahead 1 = "waitpoint" or [tipo-patch] of patch-ahead 1 = "parada-peatones"[
        fd velocidad / 200
      ]
      set tiempo-espera tiempo-espera + 1
    ]
  ]
end

to cross-the-street
  if crossing-part = 1[
    face min-one-of patches with [tipo-patch = "waitpoint2"] in-radius 4 [abs([xcor] of myself - pxcor)]
    ask patches in-cone 3 180 with [tipo-patch = "crossing"] [set cantidad-pers cantidad-pers + 1]
    set crossing-part 2
  ]
  if crossing-part = 2 [
    if heading > 315 and heading < 45 [set heading 0]
    if heading > 45 and heading < 135 [set heading 90]
    if heading > 135 and heading < 225 [set heading 180]
    if heading > 225 and heading < 315 [set heading 270]
  ]
  if tipo-patch = "waitpoint2" and crossing-part = 2 [
    rt 180
    ask patches in-cone 3 180 with [tipo-patch = "crossing"] [set cantidad-pers cantidad-pers - 1]
    lt 180
    ask patches in-cone 3 180 with [tipo-patch = "crossing"] [set cantidad-pers cantidad-pers + 1]
    set crossing-part 3
  ]
  if crossing-part = 3 and tipo-patch = "waitpoint" [
    rt 180
    ask patches in-cone 3 180 with [tipo-patch = "crossing"] [set cantidad-pers cantidad-pers - 1]
    lt 180
    set crossing-part 0
    set tiempo-espera 0
  ]
  ifelse tipo-patch = "waitpoint" and crossing-part = 2  and ([cantidad-vehic] of patch-ahead 1 > 0 or [cantidad-vehic] of patch-ahead 2 > 0) [
    fd 0
    set espera true
  ]
  [
    ifelse tipo-patch = "waitpoint2" and crossing-part = 3 and ([cantidad-vehic] of patch-ahead 1 > 0 or [cantidad-vehic] of patch-ahead 2 > 0)[
      fd 0
      set espera true
    ]
    [
      if not any? vehiculos-on patch-ahead 1 [
        fd velocidad / 200 set espera false
      ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
149
18
1359
709
-1
-1
15.0
1
10
1
1
1
0
1
1
1
0
79
0
43
0
0
1
ticks
20.0

BUTTON
15
36
136
69
Setup sin bahías
setup-1
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
32
75
136
108
Go sin bahías
go-1
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

SLIDER
1371
18
1543
51
num-carros
num-carros
0
200
0
1
1
NIL
HORIZONTAL

SLIDER
1566
18
1738
51
velocidad-carro
velocidad-carro
30
150
71
1
1
NIL
HORIZONTAL

SLIDER
1371
51
1543
84
num-personas
num-personas
0
1000
115
1
1
NIL
HORIZONTAL

SLIDER
1371
117
1543
150
num-camiones
num-camiones
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
1371
84
1543
117
num-motos
num-motos
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
1567
53
1739
86
velocidad-moto
velocidad-moto
0
100
100
1
1
NIL
HORIZONTAL

SLIDER
1567
88
1739
121
velocidad-camion
velocidad-camion
0
100
34
1
1
NIL
HORIZONTAL

SLIDER
1371
150
1543
183
num-ambulancias
num-ambulancias
0
100
1
1
1
NIL
HORIZONTAL

SLIDER
1567
123
1740
156
velocidad-ambulancias
velocidad-ambulancias
0
150
149
1
1
NIL
HORIZONTAL

MONITOR
1649
404
1770
449
Vehículos detenidos
(count vehiculos with \n    [\n      velocidad = 0\n    ])
17
1
11

MONITOR
1621
299
1771
344
Conductores irrespetuosos
(count vehiculos with \n    [\n      respeto <= 20\n    ] with [\n      ser-ambulancia = false\n    ]\n    )
17
1
11

MONITOR
1552
199
1773
244
Semáforos rojos saltados por ambulancias
sem-irrespetados-amb
17
1
11

MONITOR
1556
250
1772
295
Semáforos rojos saltados por conductores
sem-irrespetados
17
1
11

MONITOR
1626
352
1771
397
Ambulancias en emergencia
(count vehiculos with \n    [\n      emergencia = true\n    ])
17
1
11

BUTTON
10
143
136
176
Setup con bahías
setup-2
NIL
1
T
OBSERVER
NIL
C
NIL
NIL
1

BUTTON
26
182
135
215
Go con bahías
go-2
T
1
T
OBSERVER
NIL
B
NIL
NIL
1

SLIDER
1371
183
1543
216
num-autobuses
num-autobuses
0
100
25
1
1
NIL
HORIZONTAL

SLIDER
1568
156
1740
189
velocidad-autobuses
velocidad-autobuses
0
100
30
1
1
NIL
HORIZONTAL

PLOT
1370
467
1771
650
Vehiculos detenidos en el tiempo
Tiempo
Vehiculos
0.0
1000.0
0.0
200.0
true
true
"" ""
PENS
"Vehiculos detenidos" 1.0 0 -2674135 true "" "plot (count vehiculos with \n    [\n      velocidad = 0\n    ])"

@#$#@#$#@
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

ambulance
true
0
Rectangle -7500403 true true 90 90 195 270
Polygon -7500403 true true 190 4 150 4 134 41 104 56 105 90 190 90
Rectangle -1 true false 60 105 105 105
Polygon -16777216 true false 112 62 141 48 141 81 112 82
Circle -16777216 true false 174 24 42
Circle -16777216 true false 174 189 42
Rectangle -1 true false 158 3 173 12
Rectangle -1184463 true false 180 2 172 11
Rectangle -2674135 true false 151 2 158 271
Line -16777216 false 90 90 195 90
Rectangle -16777216 true false 116 172 133 217
Rectangle -16777216 true false 111 124 134 147
Line -7500403 true 105 135 135 135
Rectangle -7500403 true true 186 267 195 286
Line -13345367 false 135 255 120 225
Line -13345367 false 135 225 120 255
Line -13345367 false 112 240 142 240

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bike
true
1
Line -7500403 false 137 183 72 184
Circle -7500403 false false 65 184 22
Circle -7500403 false false 128 187 16
Circle -16777216 false false 177 148 95
Circle -16777216 false false 174 144 102
Circle -16777216 false false 24 144 102
Circle -16777216 false false 28 148 95
Polygon -2674135 true true 225 195 210 90 202 92 203 107 108 122 93 83 85 85 98 123 89 133 75 195 135 195 136 188 86 188 98 133 206 116 218 195
Polygon -2674135 true true 92 83 136 193 129 196 83 85
Polygon -2674135 true true 135 188 209 120 210 131 136 196
Line -7500403 false 141 173 130 219
Line -7500403 false 145 172 134 172
Line -7500403 false 134 219 123 219
Polygon -16777216 true false 113 92 102 92 92 97 83 100 69 93 69 84 84 82 99 83 116 85
Polygon -7500403 true false 229 86 202 93 199 85 226 81
Rectangle -16777216 true false 225 75 225 90
Polygon -16777216 true false 230 87 230 72 222 71 222 89
Circle -7500403 false false 125 184 22
Line -7500403 false 141 206 72 205

bike top
true
1
Circle -16777216 false false 102 177 95
Circle -16777216 false false 99 174 102
Circle -16777216 false false 99 24 102
Circle -16777216 false false 102 28 95
Rectangle -16777216 true false 210 225 225 225
Rectangle -2674135 false true 105 75 105 180
Rectangle -2674135 true true 135 60 165 240
Circle -2674135 true true 129 54 42
Circle -2674135 true true 129 204 42
Rectangle -16777216 true false 120 60 180 105
Rectangle -16777216 true false 90 195 210 210

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

building store
false
0
Rectangle -7500403 true true 30 45 45 240
Rectangle -16777216 false false 30 45 45 165
Rectangle -7500403 true true 15 165 285 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 30 180 105 240
Rectangle -16777216 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -7500403 true true 0 165 45 135 60 90 240 90 255 135 300 165
Rectangle -7500403 true true 0 0 75 45
Rectangle -16777216 false false 0 0 75 45

bus
true
0
Polygon -7500403 true true 206 285 150 285 120 285 105 270 105 30 120 15 135 15 206 15 210 30 210 270
Rectangle -16777216 true false 126 69 159 264
Line -7500403 true 135 240 165 240
Line -7500403 true 120 240 165 240
Line -7500403 true 120 210 165 210
Line -7500403 true 120 180 165 180
Line -7500403 true 120 150 165 150
Line -7500403 true 120 120 165 120
Line -7500403 true 120 90 165 90
Line -7500403 true 135 60 165 60
Rectangle -16777216 true false 174 15 182 285
Circle -16777216 true false 187 210 42
Rectangle -16777216 true false 127 24 205 60
Circle -16777216 true false 187 63 42
Line -7500403 true 120 43 207 43

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

car top
true
0
Polygon -7500403 true true 151 8 119 10 98 25 86 48 82 225 90 270 105 289 150 294 195 291 210 270 219 225 214 47 201 24 181 11
Polygon -16777216 true false 210 195 195 210 195 135 210 105
Polygon -16777216 true false 105 255 120 270 180 270 195 255 195 225 105 225
Polygon -16777216 true false 90 195 105 210 105 135 90 105
Polygon -1 true false 205 29 180 30 181 11
Line -7500403 true 210 165 195 165
Line -7500403 true 90 165 105 165
Polygon -16777216 true false 121 135 180 134 204 97 182 89 153 85 120 89 98 97
Line -16777216 false 210 90 195 30
Line -16777216 false 90 90 105 30
Polygon -1 true false 95 29 120 30 119 11

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

crossing
true
15
Line -16777216 false 150 90 150 210
Line -16777216 false 120 90 120 210
Line -16777216 false 90 90 90 210
Line -16777216 false 240 90 240 210
Line -16777216 false 270 90 270 210
Line -16777216 false 30 90 30 210
Line -16777216 false 60 90 60 210
Line -16777216 false 210 90 210 210
Line -16777216 false 180 90 180 210
Rectangle -1 true true 0 0 30 300
Rectangle -7500403 true false 120 0 150 300
Rectangle -1 true true 180 0 210 300
Rectangle -7500403 true false 240 0 270 300
Rectangle -1 true true 30 0 60 300
Rectangle -7500403 true false 90 0 120 300
Rectangle -1 true true 150 0 180 300
Rectangle -7500403 true false 270 0 300 300
Rectangle -1 true true 60 0 90 300
Rectangle -1 true true 210 0 240 300

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

entrada-bahia
true
0
Polygon -7500403 true true 300 240 285 210 270 180 270 150 300 135 300 225
Polygon -7500403 true true 225 0 210 15 210 30 255 60 285 45 300 30 300 0
Polygon -7500403 true true 300 60 240 75 255 105 285 120 300 105
Polygon -7500403 true true 0 0 300 300 300 0 0 0

entrada-bahia-2
true
0
Polygon -7500403 true true 0 240 45 195 75 180 90 165 90 135 45 120 0 135
Polygon -7500403 true true 300 240 285 210 270 180 270 150 300 135 300 225
Polygon -7500403 true true 225 300 240 270 270 255 285 255 300 285 300 300
Polygon -7500403 true true 0 285 30 300 0 300
Polygon -7500403 true true 225 0 210 15 210 30 255 60 285 45 300 30 300 0
Polygon -7500403 true true 0 30 30 0 0 0
Polygon -7500403 true true 15 30 75 0 180 0 195 30 225 60 210 90 135 60 45 60
Polygon -7500403 true true 0 105 30 105 75 120 105 105 90 75 45 75 0 60
Polygon -7500403 true true 300 60 240 75 255 105 285 120 300 105
Polygon -7500403 true true 120 75 120 105 105 135 105 165 165 150 240 150 255 135 240 105 210 105 180 90 150 75
Polygon -7500403 true true 75 300 135 285 195 300
Polygon -7500403 true true 30 285 75 285 120 270 150 270 150 210 90 195 60 210 15 255
Polygon -7500403 true true 180 285 240 255 255 225 255 195 240 165 195 165 150 165 135 195 165 210 165 255
Polygon -7500403 true true 0 0 300 300 300 0 0 0

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house bungalow
false
0
Rectangle -7500403 true true 210 75 225 255
Rectangle -7500403 true true 90 135 210 255
Rectangle -16777216 true false 165 195 195 255
Line -16777216 false 210 135 210 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 150 75 150 150 75
Line -16777216 false 75 150 225 150
Line -16777216 false 195 120 225 150
Polygon -16777216 false false 165 195 150 195 180 165 210 195
Rectangle -16777216 true false 135 105 165 135

house colonial
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Polygon -7500403 true true 30 135 285 135 240 90 75 90
Line -16777216 false 30 135 285 135
Line -16777216 false 255 105 285 135
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

house efficiency
false
0
Rectangle -7500403 true true 180 90 195 195
Rectangle -7500403 true true 90 165 210 255
Rectangle -16777216 true false 165 195 195 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 165 75 165 150 90
Line -16777216 false 75 165 225 165

house ranch
false
0
Rectangle -7500403 true true 270 120 285 255
Rectangle -7500403 true true 15 180 270 255
Polygon -7500403 true true 0 180 300 180 240 135 60 135 0 180
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 45 195 105 240
Rectangle -16777216 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -16777216 false 270 180 270 255
Line -16777216 false 0 180 300 180

house two story
false
0
Polygon -7500403 true true 2 180 227 180 152 150 32 150
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Polygon -7500403 true true 60 135 285 135 240 90 105 90
Line -16777216 false 75 135 75 180
Rectangle -16777216 true false 30 195 93 240
Line -16777216 false 60 135 285 135
Line -16777216 false 255 105 285 135
Line -16777216 false 0 180 75 180
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

lights
false
0
Rectangle -16777216 true false 15 15 285 285
Rectangle -7500403 true true 30 30 270 270

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

parada
true
0
Rectangle -7500403 true true 0 0 300 300
Rectangle -1 true false 60 255 225 390
Rectangle -1 true false 0 0 300 45
Rectangle -1184463 true false 15 15 45 30
Rectangle -1184463 true false 75 15 105 30
Rectangle -1184463 true false 135 15 165 30
Rectangle -1184463 true false 195 15 225 30
Rectangle -1184463 true false 255 15 285 30

parada-peatones
true
0
Polygon -7500403 true true 0 240 45 195 75 180 90 165 90 135 45 120 0 135
Polygon -7500403 true true 300 240 285 210 270 180 270 150 300 135 300 225
Polygon -7500403 true true 225 300 240 270 270 255 285 255 300 285 300 300
Polygon -7500403 true true 0 285 30 300 0 300
Polygon -7500403 true true 225 0 210 15 210 30 255 60 285 45 300 30 300 0
Polygon -7500403 true true 0 30 30 0 0 0
Polygon -7500403 true true 15 30 75 0 180 0 195 30 225 60 210 90 135 60 45 60
Polygon -7500403 true true 0 105 30 105 75 120 105 105 90 75 45 75 0 60
Polygon -7500403 true true 300 60 240 75 255 105 285 120 300 105
Polygon -7500403 true true 120 75 120 105 105 135 105 165 165 150 240 150 255 135 240 105 210 105 180 90 150 75
Polygon -7500403 true true 75 300 135 285 195 300
Polygon -7500403 true true 30 285 75 285 120 270 150 270 150 210 90 195 60 210 15 255
Polygon -7500403 true true 180 285 240 255 255 225 255 195 240 165 195 165 150 165 135 195 165 210 165 255
Polygon -2674135 true false 0 180 45 120 255 120 300 165 300 0 0 0 0 180 45 120

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person business
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -7500403 true true 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true false 195 225 195 300 270 270 270 195
Rectangle -13791810 true false 180 225 195 300
Polygon -14835848 true false 180 226 195 226 270 196 255 196
Polygon -13345367 true false 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

person construction
false
0
Rectangle -7500403 true true 123 76 176 95
Polygon -1 true false 105 90 60 195 90 210 115 162 184 163 210 210 240 195 195 90
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Circle -7500403 true true 110 5 80
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -955883 true false 180 90 195 90 195 165 195 195 150 195 150 120 180 90
Polygon -955883 true false 120 90 105 90 105 165 105 195 150 195 150 120 120 90
Rectangle -16777216 true false 135 114 150 120
Rectangle -16777216 true false 135 144 150 150
Rectangle -16777216 true false 135 174 150 180
Polygon -955883 true false 105 42 111 16 128 2 149 0 178 6 190 18 192 28 220 29 216 34 201 39 167 35
Polygon -6459832 true false 54 253 54 238 219 73 227 78
Polygon -16777216 true false 15 285 15 255 30 225 45 225 75 255 75 270 45 285

person doctor
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -13345367 true false 135 90 150 105 135 135 150 150 165 135 150 105 165 90
Polygon -7500403 true true 105 90 60 195 90 210 135 105
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -1 true false 105 90 60 195 90 210 114 156 120 195 90 270 210 270 180 195 186 155 210 210 240 195 195 90 165 90 150 150 135 90
Line -16777216 false 150 148 150 270
Line -16777216 false 196 90 151 149
Line -16777216 false 104 90 149 149
Circle -1 true false 180 0 30
Line -16777216 false 180 15 120 15
Line -16777216 false 150 195 165 195
Line -16777216 false 150 240 165 240
Line -16777216 false 150 150 165 150

person farmer
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 60 195 90 210 114 154 120 195 180 195 187 157 210 210 240 195 195 90 165 90 150 105 150 150 135 90 105 90
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -13345367 true false 120 90 120 180 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 180 90 172 89 165 135 135 135 127 90
Polygon -6459832 true false 116 4 113 21 71 33 71 40 109 48 117 34 144 27 180 26 188 36 224 23 222 14 178 16 167 0
Line -16777216 false 225 90 270 90
Line -16777216 false 225 15 225 90
Line -16777216 false 270 15 270 90
Line -16777216 false 247 15 247 90
Rectangle -6459832 true false 240 90 255 300

person graduate
false
0
Circle -16777216 false false 39 183 20
Polygon -1 true false 50 203 85 213 118 227 119 207 89 204 52 185
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -8630108 true false 90 19 150 37 210 19 195 4 105 4
Polygon -8630108 true false 120 90 105 90 60 195 90 210 120 165 90 285 105 300 195 300 210 285 180 165 210 210 240 195 195 90
Polygon -1184463 true false 135 90 120 90 150 135 180 90 165 90 150 105
Line -2674135 false 195 90 150 135
Line -2674135 false 105 90 150 135
Polygon -1 true false 135 90 150 105 165 90
Circle -1 true false 104 205 20
Circle -1 true false 41 184 20
Circle -16777216 false false 106 206 18
Line -2674135 false 208 22 208 57

person lumberjack
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -2674135 true false 60 196 90 211 114 155 120 196 180 196 187 158 210 211 240 196 195 91 165 91 150 106 150 135 135 91 105 91
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -6459832 true false 174 90 181 90 180 195 165 195
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -6459832 true false 126 90 119 90 120 195 135 195
Rectangle -6459832 true false 45 180 255 195
Polygon -16777216 true false 255 165 255 195 240 225 255 240 285 240 300 225 285 195 285 165
Line -16777216 false 135 165 165 165
Line -16777216 false 135 135 165 135
Line -16777216 false 90 135 120 135
Line -16777216 false 105 120 120 120
Line -16777216 false 180 120 195 120
Line -16777216 false 180 135 210 135
Line -16777216 false 90 150 105 165
Line -16777216 false 225 165 210 180
Line -16777216 false 75 165 90 180
Line -16777216 false 210 150 195 165
Line -16777216 false 180 105 210 180
Line -16777216 false 120 105 90 180
Line -16777216 false 150 135 150 165
Polygon -2674135 true false 100 30 104 44 189 24 185 10 173 10 166 1 138 -1 111 3 109 28

person police
false
0
Polygon -1 true false 124 91 150 165 178 91
Polygon -13345367 true false 134 91 149 106 134 181 149 196 164 181 149 106 164 91
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -13345367 true false 120 90 105 90 60 195 90 210 116 158 120 195 180 195 184 158 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Polygon -13345367 true false 150 26 110 41 97 29 137 -1 158 6 185 0 201 6 196 23 204 34 180 33
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Rectangle -16777216 true false 109 183 124 227
Rectangle -16777216 true false 176 183 195 205
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Polygon -1184463 true false 172 112 191 112 185 133 179 133
Polygon -1184463 true false 175 6 194 6 189 21 180 21
Line -1184463 false 149 24 197 24
Rectangle -16777216 true false 101 177 122 187
Rectangle -16777216 true false 179 164 183 186

person service
false
0
Polygon -7500403 true true 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -1 true false 120 90 105 90 60 195 90 210 120 150 120 195 180 195 180 150 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Polygon -1 true false 123 90 149 141 177 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -2674135 true false 180 90 195 90 183 160 180 195 150 195 150 135 180 90
Polygon -2674135 true false 120 90 105 90 114 161 120 195 150 195 150 135 120 90
Polygon -2674135 true false 155 91 128 77 128 101
Rectangle -16777216 true false 118 129 141 140
Polygon -2674135 true false 145 91 172 77 172 101

person soldier
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

person student
false
0
Polygon -13791810 true false 135 90 150 105 135 165 150 180 165 165 150 105 165 90
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 100 210 130 225 145 165 85 135 63 189
Polygon -13791810 true false 90 210 120 225 135 165 67 130 53 189
Polygon -1 true false 120 224 131 225 124 210
Line -16777216 false 139 168 126 225
Line -16777216 false 140 167 76 136
Polygon -7500403 true true 105 90 60 195 90 210 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

road
true
0
Rectangle -7500403 true true 0 0 300 300
Rectangle -1 true false 0 75 300 225

road-middle
true
0
Rectangle -7500403 true true 0 0 300 300
Rectangle -1184463 true false 0 90 300 210

road2
true
0
Rectangle -7500403 true true 0 0 300 300
Rectangle -1 true false 60 255 225 390

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tile brick
false
0
Rectangle -1 true false 0 0 300 300
Rectangle -7500403 true true 15 225 150 285
Rectangle -7500403 true true 165 225 300 285
Rectangle -7500403 true true 75 150 210 210
Rectangle -7500403 true true 0 150 60 210
Rectangle -7500403 true true 225 150 300 210
Rectangle -7500403 true true 165 75 300 135
Rectangle -7500403 true true 15 75 150 135
Rectangle -7500403 true true 0 0 60 60
Rectangle -7500403 true true 225 0 300 60
Rectangle -7500403 true true 75 0 210 60

tile stones
false
0
Polygon -7500403 true true 0 240 45 195 75 180 90 165 90 135 45 120 0 135
Polygon -7500403 true true 300 240 285 210 270 180 270 150 300 135 300 225
Polygon -7500403 true true 225 300 240 270 270 255 285 255 300 285 300 300
Polygon -7500403 true true 0 285 30 300 0 300
Polygon -7500403 true true 225 0 210 15 210 30 255 60 285 45 300 30 300 0
Polygon -7500403 true true 0 30 30 0 0 0
Polygon -7500403 true true 15 30 75 0 180 0 195 30 225 60 210 90 135 60 45 60
Polygon -7500403 true true 0 105 30 105 75 120 105 105 90 75 45 75 0 60
Polygon -7500403 true true 300 60 240 75 255 105 285 120 300 105
Polygon -7500403 true true 120 75 120 105 105 135 105 165 165 150 240 150 255 135 240 105 210 105 180 90 150 75
Polygon -7500403 true true 75 300 135 285 195 300
Polygon -7500403 true true 30 285 75 285 120 270 150 270 150 210 90 195 60 210 15 255
Polygon -7500403 true true 180 285 240 255 255 225 255 195 240 165 195 165 150 165 135 195 165 210 165 255

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

tree pine
false
0
Rectangle -6459832 true false 120 225 180 300
Polygon -7500403 true true 150 240 240 270 150 135 60 270
Polygon -7500403 true true 150 75 75 210 150 195 225 210
Polygon -7500403 true true 150 7 90 157 150 142 210 157 150 7

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

truck cab top
true
0
Rectangle -7500403 true true 70 45 227 120
Polygon -7500403 true true 150 8 118 10 96 17 90 30 75 135 75 195 90 210 150 210 210 210 225 195 225 135 209 30 201 17 179 10
Polygon -16777216 true false 94 135 118 119 184 119 204 134 193 141 110 141
Line -16777216 false 130 14 168 14
Line -16777216 false 130 18 168 18
Line -16777216 false 130 11 168 11
Line -16777216 false 185 29 194 112
Line -16777216 false 115 29 106 112
Line -16777216 false 195 225 210 240
Line -16777216 false 105 225 90 240
Polygon -16777216 true false 210 195 195 195 195 150 210 143
Polygon -16777216 false false 90 143 90 195 105 195 105 150 90 143
Polygon -16777216 true false 90 195 105 195 105 150 90 143
Line -7500403 true 210 180 195 180
Line -7500403 true 90 180 105 180
Line -16777216 false 212 44 213 124
Line -16777216 false 88 44 87 124
Line -16777216 false 223 130 193 112
Rectangle -7500403 true true 225 133 244 139
Rectangle -7500403 true true 56 133 75 139
Rectangle -7500403 true true 120 210 180 240
Rectangle -7500403 true true 93 238 210 270
Rectangle -16777216 true false 200 217 224 278
Rectangle -16777216 true false 76 217 100 278
Circle -16777216 false false 135 240 30
Line -16777216 false 77 130 107 112
Rectangle -16777216 false false 107 149 192 210
Rectangle -1 true false 180 9 203 17
Rectangle -1 true false 97 9 120 17

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

van side
false
0
Polygon -7500403 true true 26 147 18 125 36 61 161 61 177 67 195 90 242 97 262 110 273 129 260 149
Circle -16777216 true false 43 123 42
Circle -16777216 true false 194 124 42
Polygon -16777216 true false 45 68 37 95 183 96 169 69
Line -7500403 true 62 65 62 103
Line -7500403 true 115 68 120 100
Polygon -1 true false 271 127 258 126 257 114 261 109
Rectangle -16777216 true false 19 131 27 142

van top
true
0
Polygon -7500403 true true 90 117 71 134 228 133 210 117
Polygon -7500403 true true 150 8 118 10 96 17 85 30 84 264 89 282 105 293 149 294 192 293 209 282 215 265 214 31 201 17 179 10
Polygon -16777216 true false 94 129 105 120 195 120 204 128 180 150 120 150
Polygon -16777216 true false 90 270 105 255 105 150 90 135
Polygon -16777216 true false 101 279 120 286 180 286 198 281 195 270 105 270
Polygon -16777216 true false 210 270 195 255 195 150 210 135
Polygon -1 true false 201 16 201 26 179 20 179 10
Polygon -1 true false 99 16 99 26 121 20 121 10
Line -16777216 false 130 14 168 14
Line -16777216 false 130 18 168 18
Line -16777216 false 130 11 168 11
Line -16777216 false 185 29 194 112
Line -16777216 false 115 29 106 112
Line -7500403 false 210 180 195 180
Line -7500403 false 195 225 210 240
Line -7500403 false 105 225 90 240
Line -7500403 false 90 180 105 180

waitpoint
false
14
Rectangle -16777216 true true 15 15 285 285
Rectangle -7500403 true false 30 30 270 270

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="hit" repetitions="20" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>hit</metric>
    <enumeratedValueSet variable="lights-interval">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-to-crossing">
      <value value="510"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="acceleration">
      <value value="0.248"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-limit">
      <value value="74"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="deceleration">
      <value value="0.057"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-of-people">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-of-cars">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="basic-politeness">
      <value value="0"/>
      <value value="50"/>
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="turning-left?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-of-turning">
      <value value="46"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="standing - trafficLightsInterval" repetitions="15" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>standing</metric>
    <enumeratedValueSet variable="turning-left?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="acceleration">
      <value value="0.185"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="basic-politeness">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-to-crossing">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-of-turning">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="deceleration">
      <value value="0.057"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-limit">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-of-cars">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-of-people">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lights-interval">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="standing-politeness" repetitions="20" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>standing</metric>
    <enumeratedValueSet variable="basic-politeness">
      <value value="0"/>
      <value value="50"/>
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-of-cars">
      <value value="183"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="deceleration">
      <value value="0.057"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="acceleration">
      <value value="0.185"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="turning-left?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="time-to-crossing">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-of-turning">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-of-people">
      <value value="76"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-limit">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="lights-interval">
      <value value="4"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
