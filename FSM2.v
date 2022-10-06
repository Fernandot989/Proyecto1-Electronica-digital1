module Entregar(input enable, siguiente, clk, reset, output reg Y2, Y3); //De las variables a utilizar se clasifican entre inputs y outputs
    reg [2:0] state, next_state;	//Se establecen los estados con 3 bits
    parameter Ordenrecibida = 3'b000, Prepararorden = 3'b001, Empacarorden = 3'b010, Enviarorden = 3'b011, Ordenentregada = 3'b100; //Se establecen los 5 estados con 3 bits
	
    // Nube combinacional para calcular el estado futuro y salidas	
    always @ (enable or siguiente or state) begin
        case (state)
            Ordenrecibida: begin		//En Orden recibida se establece: si enable es presionado pasa al estado Preparar orden,
                    if (enable == 1)	//si no, se queda en Orden recibida
                        next_state <= Prepararorden;
					else
						next_state <= Ordenrecibida;
                end
            Prepararorden: begin		//En Preparar orden se establece: si siguiente es presionado pasa al estado Empacar orden,
                    if (siguiente == 1) //si no, se queda en Prepara orden
                        next_state <= Empacarorden;
					else
						next_state <= Prepararorden;
                end
            Empacarorden: begin			//En Empacar orden se establece: si siguiente es presionado pasa al estado Enviar orden,
                    if (siguiente == 1) //si no, se queda en Empacar orden
                        next_state <= Enviarorden; 
					else
						next_state <= Empacarorden;
                end
			Enviarorden: begin			//En Enviar orden se establece: si siguiente es presionado pasa al estado Orden entregada,
                    if (siguiente == 1) //si no, se queda en Enviar orden
                        next_state <= Ordenentregada; 
					else
						next_state <= Enviarorden;
                end
			Ordenentregada: begin		//En Orden entregada orden se establece: si siguiente es presionado pasa al estado Orden recibida,
                    if (siguiente == 1) //si no, se queda en Orden entregada
                        next_state <= Ordenrecibida; 
					else
						next_state <= Ordenentregada;
                end
            default: 					//el estado de origen es Orden recibida
				next_state <= Ordenrecibida; 
        endcase
    end

    // Banco de flip flops
    always @ (posedge clk or posedge reset) begin	//Por cada flanco positivo de reloj se activa la acción deseada

        if (reset == 1)
            state <= Ordenrecibida;
        else
            state <= next_state;
    end
	initial state <= 3'b000;
	
    // Nube combinacional para calcular las salidas
	 always @ (state) begin
        case (state)
            Ordenrecibida: begin 	//En el estado Orden recibida Y2 se ilumina y Y3 se apaga
				Y2 <= 1'b1;
				Y3 <= 1'b0;
				end
            Prepararorden: begin 	//En el estado Prepara orden tanto Y2 como Y3 estan apagados
				Y2 <= 1'b0;
				Y3 <= 1'b0;
				end
            Empacarorden: begin 	//En el estado Empacar orden tanto Y2 como Y3 estan apagados
				Y2 <= 1'b0;
				Y3 <= 1'b0;
				end
			Enviarorden: begin 		//En el estado Enviar orden tanto Y2 como Y3 estan apagados
				Y2 <= 1'b0;
				Y3 <= 1'b0;
				end
			Ordenentregada: begin 	//En el estado Orden entregada Y3 se ilumina y Y2 se apaga
				Y2 <= 1'b0;
				Y3 <= 1'b1;
				end
            default: begin			//En su estado de origen Y2 y Y3 estan apagados
				Y2 <= 1'b0;
				Y3 <= 1'b0;
				end
        endcase
    end
endmodule