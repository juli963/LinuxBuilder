// SPDX-License-Identifier: GPL-2.0+
/*
 * (C) Copyright 2016 Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <dm.h>
#include <env.h>
#include <init.h>
#include <asm/io.h>
#include <dm/pinctrl.h>

#include <asm/arch-rockchip/gpio.h>
#include <asm/arch-rockchip/grf_rk3568.h>
#include <dt-bindings/pinctrl/rockchip.h>

#define SYSGRF_BASE 0xFDC60000

int rk_board_late_init(void)
{
	//struct rockchip_gpio_regs * const gpio0 = (void *)GPIO0_BASE;
	struct rk3568_grf * const sysgrf = (void *)SYSGRF_BASE;

	//struct udevice *pinctrl;
	unsigned int temp;
	//printf("%s: Julis NAS Board Init... \nEnabling Ethernet Reference Clocks\n", __func__);

	//temp = readl(&sysgrf->gpio2c_iomux_l);
	//temp = (0x07<<20) | (0x02<<4);
	//writel(temp, &sysgrf->gpio2c_iomux_l);



	//temp = readl(&sysgrf->gpio3b_iomux_l);
	//temp = (0x07<<16) | (0x03<<0);
	//writel(temp, &sysgrf->gpio3b_iomux_l);
/*
	ret = uclass_get_device(UCLASS_PINCTRL, 0, &pinctrl);
	if (ret) {
		debug("%s: Cannot find pinctrl device\n", __func__);
		goto err;
	}

	const struct pinctrl_ops *ops = pinctrl->driver->ops;
	ret = ops->pinmux_set(pinctrl, GPIO(BANK_C, RK_PC1), RK_FUNC_2);	// ETH0 RefCLK25
	if (ret) {
		debug("%s: Failed to set GMAC0 25MHz RefClock\n", __func__);
		goto err;
	}

	ret = ops->pinmux_set(pinctrl, GPIO(BANK_D, RK_PB0), RK_FUNC_3); // ETH1 RefCLK25
	if (ret) {
		debug("%s: Failed to set GMAC1 25MHz RefClock\n", __func__);
		goto err;
	}
*/
	return 0;
/*
	err:
	printf("spl_board_init: Error %d\n", ret);
	while(1);
*/
}

