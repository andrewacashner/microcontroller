#ifndef SINCOS_H
#define SINCOS_H

#include "ti_msp_dl_config.h"

void mathacl_init(void);

void sincos(float degrees, float *cos, float *sin);

#endif /* SINCOS_H */