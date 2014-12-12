//============================================================================
// Name        : Throw.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
#include <fstream>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include "Puma_OP.h"

using namespace std;

int main() {
	ofstream f;
	f.open("/usr/local/pipes/gripper");


	// Start Position
	MOVETO_JOINTS_WO_CHECK(-15, -190, 90, 320, 90, 90);

	// Sleep
	sleep(2);
	setSpeed(200);

	// End Position
	MOVETO_JOINTS_WO_CHECK(-90, -160, 90, 0, 90, 90);


	// Sleep
	usleep(715000);

	// Open gripper
	f << 'o' << endl;

	sleep(1);
	MOVETO_JOINTS(-60, -200, 110, 0, 90, 70);
	setSpeed(50);

	f.close();

	return 0;
}

