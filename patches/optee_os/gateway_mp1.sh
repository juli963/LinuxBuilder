#!/bin/bash
Path=../../build/optee_os
Line="
&pinctrl {
	usart1_pins_b: usart1-1 {
		pins1 {
			pinmux = <STM32_PINMUX('A', 9, AF7)>; /* USART1_TX */
			bias-disable;
			drive-push-pull;
			slew-rate = <0>;
		};
		pins2 {
			pinmux = <STM32_PINMUX('D', 14, AF7)>; /* USART1_RX */
			bias-pull-up;
		};
	};
};
"

cp -R gateway_mp1/* $Path
echo -e "$Line"  >> $Path/core/arch/arm/dts/stm32mp13-pinctrl.dtsi

echo "Add the following lines to: build/optee_os/core/arch/arm/plat-stm32mp1/conf.mk"
echo 'Conf.mk:
		flavor_dts_file-gateway_mp1 = stm32mp1_gateway_stm32mp13.dts

		flavorlist-cryp-512M = $(flavor_dts_file-157C_DK2) \
		       $(flavor_dts_file-157C_DK2_SCMI) \
		       $(flavor_dts_file-135F_DK) \
			   $(flavor_dts_file-gateway_mp1)

		flavorlist-MP13 = $(flavor_dts_file-135F_DK) \
		$(flavor_dts_file-gateway_mp1)
		'
		
echo "Waiting for Keypress"
gnome-terminal -- nano $Path/core/arch/arm/plat-stm32mp1/conf.mk
read -n 1 
