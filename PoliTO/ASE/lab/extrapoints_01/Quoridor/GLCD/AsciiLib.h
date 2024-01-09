/***************************Copyright (c)***************************************
**
**                                 http://www.powermcu.com
**
**--------------File Info-------------------------------------------------------
** File name:			AsciiLib.h
** Descriptions:		None
**
**------------------------------------------------------------------------------
** Created by:			AVRman
** Created date:		2010-11-2
** Version:				1.0
** Descriptions:		The original version
**
**------------------------------------------------------------------------------
** Modified by:
** Modified date:
** Version:
** Descriptions:
********************************************************************************/

#ifndef __AsciiLib_H
#define __AsciiLib_H

/* Includes ------------------------------------------------------------------*/
#include <string.h>

/* Private define ------------------------------------------------------------*/
// #define ASCII_8X16_MS_Gothic
// #define  ASCII_8X16_System
#define ASCII_8x8_FONT

#define FONT_WIDTH 8
#define FONT_HEIGHT 8

#define FLIP

/* Private function prototypes -----------------------------------------------*/
void get_ASCII_code(char *buffer, const char ASCII);

#endif

/*******************************************************************************
      END FILE
*******************************************************************************/
