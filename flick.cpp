#include "flick.h"
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <stdio.h>
#include <fcntl.h>
#include <iostream>
#include <signal.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <mraa/common.hpp>
#include <mraa/gpio.hpp>

static int i2cFd = -1;
static int data = 0;

#define GESTIC_XYZ_DATA		16
#define GESTIC_GESTURE_DATA    	6
#define GESTIC_TOUCH_DATA      	10


volatile sig_atomic_t flag = 1;

void
sig_handler(int signum)
{
    if (signum == SIGINT) {
        std::cout << "Exiting..." << std::endl;
        flag = 0;
    }
}

Flick::Flick(uint8_t xferPin, uint8_t resetPin) {

//	signal(SIGINT, sig_handler);

	this->touchCallback = NULL;
	this->airWheelCallback = NULL;
	this->gestureCallback = NULL;
	this->xyzCallback = NULL;
	this->xfer = xferPin;
	this->rst = resetPin;
	this->addr = I2C_DEV_ADDR;
	this->gesture = NO_GESTURE;
	this->touch = FLICK_TOUCH_NOT_DEFINED;
	this->x = this->y = this->z = 0;
	this->angle = 0;
	this->_prevWheelAngle = 0;

  char filename[40];
	sprintf(filename,"/dev/i2c-1");
	if ((i2cFd = open(filename, O_RDWR)) < 0) {
		printf("Failed to open the bus.");
		// ERROR HANDLING; you can check errno to see what went wrong 
		return;
	}

	if (ioctl(i2cFd, I2C_SLAVE, I2C_DEV_ADDR) < 0) {
		printf("Failed to acquire bus access and/or talk to slave.\n");
		// ERROR HANDLING; you can check errno to see what went wrong 
		return;
	}
	fdatasync(i2cFd);

  mraa::Result status;
  mraa::Gpio rst_gpio(this->rst);
  status = rst_gpio.dir(mraa::DIR_OUT);
    if (status != mraa::SUCCESS) {
        printError(status);
        return;
    }

  status = rst_gpio.write(0);
        if (status != mraa::SUCCESS) {
            printError(status);
            return;
        }
  usleep(10);
  status = rst_gpio.write(1);
        if (status != mraa::SUCCESS) {
            printError(status);
            return;
        }
  usleep(50);
  int ret = _ReceiveMsg(); // receive firmware version info

}

Flick::~Flick() {
	close(i2cFd);
}

int Flick::SetRuntimeParameter(uint16_t id, uint32_t arg0, uint32_t arg1) {
	static uint8_t msg[16];
	msg[0] = 0x10;
	msg[1] = 0;
	msg[2] = 0;
	msg[3] = 0xA2;
	msg[4] = id & 0xFF;
	msg[5] = id >> 8;
	msg[6] = 0;
	msg[7] = 0;
	msg[8] = arg0 & 0xFF;
	arg0 >>= 8;
	msg[9] = arg0 & 0xFF;
	arg0 >>= 8;
	msg[10] = arg0 & 0xFF;
	arg0 >>= 8;
	msg[11] = arg0 & 0xFF;
	msg[12] = arg1 & 0xFF;
	arg1 >>= 8;
	msg[13] = arg1 & 0xFF;
	arg1 >>= 8;
	msg[14] = arg1 & 0xFF;
	arg1 >>= 8;
	msg[15] = arg1 & 0xFF;
	read(i2cFd, _receiveData, 255);
   if (_SendMsg(msg, 16) >= 0) {
	    usleep(2);
		int ret = read(i2cFd, _receiveData, 255);
		if (ret >= 16 && _receiveData[4] == 0xA2) {
			return _receiveData[6];
		}
   }
   return -1;
}

int Flick::_SendMsg(uint8_t data[], uint8_t length) {
	usleep(10000);
	int ret = write(i2cFd, data, length); 
	usleep(10000);
	return ret;
	return 0;
}

int Flick::_ReceiveMsg() {
	int ret = -1;

	mraa::Result status;
	mraa::Gpio xfer_gpio(this->xfer);
       status = xfer_gpio.dir(mraa::DIR_IN);
         if (status != mraa::SUCCESS) {
             printError(status);
             return EXIT_FAILURE;
         }

        data = xfer_gpio.read();

	if (!data) {

               status = xfer_gpio.dir(mraa::DIR_OUT);
                 if (status != mraa::SUCCESS) {
                     printError(status);
                     return EXIT_FAILURE;
                 }


               status = xfer_gpio.write(0);
                 if (status != mraa::SUCCESS) {
                     printError(status);
                     return EXIT_FAILURE;
                 }


		ret = read(i2cFd, _receiveData, 255);

                status = xfer_gpio.write(1);
                 if (status != mraa::SUCCESS) {
                     printError(status);
                     return EXIT_FAILURE;
                 }

               status = xfer_gpio.dir(mraa::DIR_IN);
                 if (status != mraa::SUCCESS) {
                     printError(status);
                     return EXIT_FAILURE;
                 }

	}
	return ret;
}

void Flick::Poll() {
	int n;
	if ((n=_ReceiveMsg())>3) {
		this->_receiveData[n] = '\0';

		switch(_receiveData[3]){
		  case 0x91:
			_ProcessSensorData(&(_receiveData[4]), n);
			break;
		  case 0x15:
			// System status
			break;
		  case 0x83:
			// Firmware data
			break;
		}
	}
}

void Flick::_ProcessSensorData(uint8_t *buffer, const uint8_t len) {
	uint8_t sysInfo = buffer[3];
	
	if (buffer[0] & (1<<4) && sysInfo & 0x01) { // position valid
		this->x = buffer[GESTIC_XYZ_DATA+1] << 8 | buffer[GESTIC_XYZ_DATA];
        this->y = buffer[GESTIC_XYZ_DATA+3] << 8 | buffer[GESTIC_XYZ_DATA+2];
        this->z = buffer[GESTIC_XYZ_DATA+5] << 8 | buffer[GESTIC_XYZ_DATA+4];
		
		if( this->xyzCallback != NULL ) this->xyzCallback(x, y, z);
	}
	
	if (buffer[0] & 0x08 && sysInfo & 0x02) { // airwheel valid
		int32_t ang = (int32_t)(buffer[14] & 0x1F) * 360 / 32;
		int32_t wheelCnt = buffer[14] >> 5;
		int32_t wheelAngle = wheelCnt * 360 + ang;
		int32_t delAng = wheelAngle - _prevWheelAngle;
		if (delAng < (-(int16_t)4*360)) {
			delAng += (8*360);
		} else if (delAng > ((int16_t)4*360)) {
			delAng -= (8*360);
		}
		this->angle += delAng;
		if( this->airWheelCallback != NULL ) this->airWheelCallback(this->angle);
		this->_prevWheelAngle = wheelAngle;
	}
	
	if( buffer[0] & 0x02 && buffer[GESTIC_GESTURE_DATA] > 0){
        // Gesture event
        this->gesture = (FlickGesture_t)(buffer[GESTIC_GESTURE_DATA] & 0x07);
		uint8_t cl = buffer[GESTIC_GESTURE_DATA+1] >> 4;
		FlickGestureClass_t gcl = cl <= 2 ? (FlickGestureClass_t)cl : GESTURE_CLASS_UNKNOWN;
        if( this->gestureCallback != NULL ) this->gestureCallback(this->gesture, gcl, buffer[GESTIC_GESTURE_DATA+2]&0x01, buffer[GESTIC_GESTURE_DATA+3]&0x80);
    }
	
	if ( buffer[0] & 0x04 ){
        // Touch event
        uint16_t touchCode = buffer[GESTIC_TOUCH_DATA+1] << 8 | buffer[GESTIC_TOUCH_DATA];
        uint16_t mask = 1;
        for(uint8_t i = 0; i < 16; i++){
          if( touchCode & mask ){
            this->touch = (FlickTouch_t)i;
            if( this->touchCallback != NULL ) this->touchCallback((FlickTouch_t)i, (uint16_t)5 * buffer[GESTIC_TOUCH_DATA+2]);
            break;
          }
          mask <<= 1;
        }
    }
}
