#include "sincos.h"

const DL_MathACL_operationConfig gSinOpConfig = {
    .opType      = DL_MATHACL_OP_TYPE_SINCOS,
    .opSign      = DL_MATHACL_OPSIGN_UNSIGNED,
    .iterations  = 10,
    .scaleFactor = 0,
    .qType       = DL_MATHACL_Q_TYPE_Q31
};

void mathacl_init(void)
{
    SYSCFG_DL_init();
}

void sincos(float degrees, float *cos, float *sin)
{
    DL_MathACL_startSinCosOperation(MATHACL, &gSinOpConfig, 0);
    DL_MathACL_waitForOperation(MATHACL);
    *cos = DL_MathACL_getResultOne(MATHACL);
    *sin = DL_MathACL_getResultTwo(MATHACL);
}