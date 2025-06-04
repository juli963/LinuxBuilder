#!/bin/bash
Path=../../build/arm-trusted-firmware
Line="
&pinctrl {
	/omit-if-no-ref/
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
echo -e "$Line"  >> $Path/fdts/stm32mp13-pinctrl.dtsi
