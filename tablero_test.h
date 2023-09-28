#ifndef TABLEROS_H
#define TABLEROS_H

#include <inttypes.h>
//tableros de test
// 0: celda vacia, 1: ficha jugador uno, 2: ficha jugador dos

static uint8_t 
tablero_test[7][7] =
{
0, 1, 0, 0, 0, 2, 0,
1, 1, 0, 0, 0, 2, 2,
0, 0, 1, 0, 2, 0, 0,
0, 0, 0, 0, 0, 2, 0,
0, 0, 2, 0, 0, 0, 0,
2, 2, 0, 1, 0, 1, 1,
0, 2, 0, 0, 0, 1, 0};

// se pueden definir otros tableros para comprobar casos

static uint8_t
tablero_test_jugadas_1s[7][7] =
{
0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0,
0, 0, 1, 1, 1, 0, 0, 
0, 0, 1, 1, 1, 0, 0, 
0, 0, 1, 1, 1, 0, 0,
0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0};

static uint8_t
tablero_test_jugadas_2s[7][7] =
{
0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0,
0, 0, 2, 2, 2, 0, 0, 
0, 0, 2, 2, 2, 0, 0, 
0, 0, 2, 2, 2, 0, 0,
0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0};

#endif
