#ifndef JUGADAS_H
#define JUGADAS_H

#include <inttypes.h>
//tableros de test
// 0: celda vacia, 1: ficha jugador uno, 2: ficha jugador dos

const int NUM_JUGADAS = 10;
static uint8_t jugada[NUM_JUGADAS][2] = 
{
	//Jugada probando ficha blanca (1) linea diagonal (x, -y)
	1, 1,
	1, 2,
	1, 3,
	1, 4,
	1, 5,
	5, 1,
	5, 2,
	5, 3,
	5, 4,
	5, 5,
};

// se pueden definir otros tableros para comprobar casos

//static uint8_t
//tablero_test2[8][8] =
//{
//0, 0, 0, 0, 0, 0, 0,
//0, 0, 0, 0, 0, 0, 0,
//0, 0, 0, 0, 0, 0, 0,
//0, 0, 0, 0, 0, 0, 0,
//0, 0, 0, 0, 0, 0, 0,
//0, 0, 0, 0, 0, 0, 0,
//0, 0, 0, 0, 0, 0, 0};

#endif
