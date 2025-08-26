# 🐳 STM32CubeIDE Docker Image

Imagem Docker personalizada para o **STM32CubeIDE 1.19.0**, projetada para padronizar e garantir a consistência dos builds de projetos STM32 em qualquer ambiente Linux, garantindo que todos os desenvolvedores e pipelines usem a mesma configuração.

---

## :dart: Funcionalidades

- **Padronização de Builds**: Garante que todos os projetos STM32 sejam compilados com a mesma configuração, evitando diferenças entre ambientes de desenvolvimento.  
- **Reprodutibilidade**: A mesma imagem pode ser utilizada em diferentes máquinas e pipelines CI/CD, garantindo resultados consistentes.  
- **Atualizada para STM32CubeIDE 1.19.0**: Base pronta com a versão específica da IDE para evitar incompatibilidades.  
- **Flexibilidade e Integração**: Suporte tanto para uso local quanto para integração em GitHub Actions e outros pipelines de CI/CD.

---

## ⚠️ Requisitos Importantes

Para cumprir os termos de uso da STMicroelectronics, **o instalador da IDE não está incluído** neste repositório.  

Você deve **baixar manualmente** o arquivo `.deb_bundle.sh.zip` correspondente à versão desejada do **STM32CubeIDE** no [site oficial da ST](https://www.st.com/en/development-tools/stm32cubeide.html) e colocá-lo na **raiz do projeto** antes de construir a imagem.

> **NOTA:** Verifique o nome do arquivo e ajuste a linha correspondente no Dockerfile, se necessário.

---

## 🔥 Como Usar

### 1. Clone o repositório

```bash
git clone https://github.com/Alfredosavi/stm32cubeide-docker.git
cd stm32cubeide-docker
```

### 2. Baixe o instalador da IDE

1. Acesse a página oficial da ST para o **[STM32CubeIDE](https://www.st.com/en/development-tools/stm32cubeide.html)**  
2. Faça o download da versão **Debian Linux Installer** correspondente à versão **1.19.0**  
3. Coloque o arquivo `.deb_bundle.sh.zip` na **raiz do projeto**

### 3. Verifique o nome do arquivo no Dockerfile

Antes de construir a imagem, verifique se o nome do arquivo `.deb_bundle.sh.zip` que você baixou corresponde ao nome usado no Dockerfile.  

No arquivo Dockerfile, há uma linha semelhante a esta (linha 14):

```dockerfile
COPY st-stm32cubeide_1.19.0_25607_20250703_0907_amd64.deb_bundle.sh.zip /tmp/stm32cubeide_installer.sh.zip
```

> **IMPORTANTE**: Modifique apenas o primeiro nome (o arquivo de origem), mantendo o caminho de destino /tmp/stm32cubeide_installer.sh.zip igual.

### 4. Construa a imagem Docker

Execute o comando abaixo na raiz do projeto para construir a imagem Docker do STM32CubeIDE.  
O parâmetro `-t` dá um **nome e uma tag** para a imagem (no exemplo, `stm32cubeide` é o nome e `1.19.0` é a tag):

```bash
docker build -t stm32cubeide:1.19.0 .
```

### 5. Execute o container

Existem **três maneiras principais de executar o container** do STM32CubeIDE, dependendo do seu objetivo:  

1. **Acessar o container com seu projeto montado**  
   Permite entrar no container e trabalhar nos arquivos do projeto sem abrir a interface gráfica. É útil para compilações e execução de scripts.

    ```bash
    docker run -it --name stm32cubeide \
    -v $(pwd):/workspace \
    stm32cubeide:1.19.0
    ```

2. **Executar com suporte à interface gráfica (GUI)**
    Montando o socket X11 do Linux, você pode abrir o STM32CubeIDE com interface gráfica dentro do container, como se estivesse rodando na sua máquina. Isso permite usar todos os recursos da IDE normalmente.

    ```bash
    docker run -it --name stm32cubeide \
    -v $(pwd):/workspace \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    stm32cubeide:1.19.0
    ```

3. **Abrir o STM32CubeIDE automaticamente**
    Para iniciar diretamente a IDE ao executar o container, basta adicionar stm32cubeide no final do comando. O container abre a GUI da IDE já pronta para uso.

    ```bash
    docker run -it --name stm32cubeide \
    -v $(pwd):/workspace \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    stm32cubeide:1.19.0 stm32cubeide
    ```

> **NOTA:** No container contendo a imagem do STM32CubeIDE, estão disponíveis **três comandos** principais:  
>
> - `stm32cubeide` → inicia a IDE no modo GUI usando X11  
> - `stm32cubeide_wayland` → inicia a IDE no modo GUI usando Wayland  
> - `headless-build.sh` → executa builds de projetos STM32 em modo headless (sem interface gráfica)  
>
> O diretório de instalação do STM32CubeIDE dentro do container é:  
> `/opt/st/stm32cubeide_1.19.0/`

> **NOTA**: Para utilização em modo GUI, o host Linux precisa permitir conexões X11 (por exemplo, xhost +local:docker ou equivalente).

---

## ⚡️ Como Contribuir

1. Faça um fork deste repositório  
2. Crie uma branch com a sua feature:

    ```bash
    git checkout -b minha-feature
    ```

3. Faça commit das suas alterações:

    ```bash
    git commit -m 'feat: Minha nova feature'
    ```

4. Faça push para a sua branch:

    ```bash
    git push origin minha-feature
    ```

---

## :small_blue_diamond: Créditos

- **[STMicroelectronics](https://www.st.com/)** pela IDE STM32CubeIDE  
- Esta imagem Docker foi **baseada** no trabalho de **[xanderhendriks](https://github.com/xanderhendriks/docker-stm32cubeide)**

---

## :memo: Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](./LICENSE) para mais detalhes.
