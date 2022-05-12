# Funções

## conventional_freq_beamforming
Função que processa os dados, no domínio da frequência, utilizando o beamforming convencional.

```
out = conventional_freq_beamforming(audio, mic_array, "freq",[2000,3000],"distance",2,"size",3,"frame_size",0.1) 

figure()
out.plot("freq",1000,"DR",10)
```

	- Entradas
		- Obrigatórias
			-	audio - Objeto SAudio ou itaAudio;
			-	array - Objeto MicArray;
			-	"freq" - Valor de frequência ou array de valores a serem processsados;
			-	"distance" - Distância em metros do plano de medição até o array;
		- Opcionais
			- "size" - Tamanho ("size" x "size") da imagem a ser gerada (default = 2 m)
			- "frame_size" - Discretização da imagem em metros (default = 0.2 m)
	
	- A função retorna um objeto BeamformingResult;

## functional_beamforming

Função que processa os dados utilizando o beamforming funcional.
```
out = functional_beamforming(audio, mic_array, "freq",[2000,3000],"distance",2,"size",3,"frame_size",0.1,"nu",3)

figure()
out.plot("freq",1000,"DR",10)
```



	- Entradas
		- Obrigatórias
			-	audio - Objeto SAudio ou itaAudio;
			-	array - Objeto MicArray;
			-	"freq" - Valor de frequência ou array de valores a serem processsados;
			-	"distance" - Distância em metros do plano de medição até o array;
		- Opcionais
			- "size" - Tamanho ("size" x "size") da imagem a ser gerada (default = 2 m)
			- "frame_size" - Discretização da imagem em metros (default = 0.2 m)
			- "diag_zero" - Zera a diagonal principal ao calcular a matriz de espectros cruzados (default = false)
			- 'nu' - Valor exponencial do beamforming convencional
	- A função retorna um objeto BeamformingResult;


referência: http://www.bebec.eu/Downloads/BeBeC2014/Papers/BeBeC-2014-01.pdf
# Classes

## MicArray

### Criando o objeto

O objeto pode ser criado colocando as posições dos microfones manualmente,
```
mic_array = MicArray('x',[-1,0,1],'y',[1 1 1], 'z', [0 0 0],'H',1.2)
```
carregando dados de um .txt,
```
mic_array = MicArray('load','arquivo.txt','H',1.2)
```
ou gerando através de uma geometria pré-estabelecida.

```
mic_array = MicArray
mic_array.generate_array('spiral')
%%% ou
mic_array.generate_array('circle')
%%% ps: ainda falta mapear os parâmetros para cada geomêtria.
```
O parâmetro 'H' é opcional, ele é utilizado para passar os dados de altura do centro do array, caso isso já não esteja contabilizado nas posições no eixo y.

### plot (método)
Plota as posições do microfone no eixo x-y.
```
mic_array.plot()
```

	
### origin (método)
Retorna as posições da origem do array.
```
origin = mic_array.origin();
origin('x')
origin('y')
origin('z')
```

### position (propriedade)

Posição dos microfones do array

```
mic_array.position('x')
mic_array.position('y')
mic_array.position('z')
```

## SAudio

### Criando o objeto
```
audio_data = SAudio('data', time_data ,'Fs',Fs,'c0',343);
```
A variável ```c0 ```  é opcional e tem por padrão o valor 343 m/s.
### plot_time ( método)
Método que faz o plot no domínio do tempo
```
audio_data.plot_time(numero_do_mic)
```

### plot_freq ( método )
Método que faz o plot no domínio da frequência
```
audio_data.plot_freq(numero_do_mic)
```
### time_data (propriedade)
Dados no domínio do tempo
```
audio_data.time_data
```
### time_vector (propriedade)
Vetor de tempo
```
audio_data.time_vector
```

### freq_data (propriedade)
Dados no domínio da frequência
```
audio_data.freq_data
```
### freq_vector(propriedade)
Vetor de frequências
```
audio_data.freq_vector
```

## ImageToPlot

Objeto utilizado para carregar uma imagem e plotá-la.

### Criando o objeto

```
img = ImageToPlot('local_da _imagem','figure_length',tamanho_da_imagem_em_metros);
```

### Plot (método)
O valor de transparência da imagem vai de 0 a 1.

```
img.plot('alpha',transparencia_da_imagem);

```

## BeamformingResult 

Objeto utilizado para guardar os dados processados do imageamento e plotá-los.

### plot ( método )  
```
figure()
output_beamforming.plot('freq',3000,'DR',10)
xlabel('x (m)')
ylabel('y (m)')
```



	- Entradas
		- Obrigatórias
			- "freq" - Frequência para o plot
		- Opcionais
			- "DR" - Faixa dinâmica do plot (default = 10 dB);
			- "interp" - Aplica shading interp na imagem gerada (default = true);
			- "transparent" - Deixa os valores abaixo da diferença de faixa dinâmica transparentes;
			- "dB" - Plota os valores da imagem em dB (default = true);

