 #!/bin/bash
  ##########################################################################
  #### SUPORTE REGIONAL - SANTA INÊS - MA
  #### Nilsonlinux
  export DIR="$(dirname "$(readlink -f "$0")")"
##########################################################################
  OPEN="play $DIR/sounds-alert/window-new.oga"
  CLOSE="play $DIR/sounds-alert/window-close.oga"
  ERRO="play $DIR/sounds-alert/erro.oga"
  CONECTADO="play $DIR/sounds-alert/ok.oga"
##########################################################################
VAR_FORM=$( \
   ${OPEN} | GTK_THEME="Ncode Dark Theme" yad --form --borders=10 \
        --center \
        --title="NCODE - GERADOR DE CÓDIGO DE BARRAS - EAN13" \
        --width=500 \
        --height=100 \
        --image="$DIR/img/ncode.png" \
        --field="N O M E" "" \
        --field="C A R G O":CB OPERADOR!FISCAL!CPD!GERENTE \
        --field="C Ó D I G O" $CODIGO ""  \
        --field="L O J A S":CB SUPER!MIX!CAMIÑO!ELETRO!GRUPO $LOJA ""  \
        --button="CANCELAR":1 --button="GERAR CÓDIGO":0)
      # --field="T I P O":CB EAN13!EAN8!CODE39!CODE93!CODE11!CODE128!CODABAR!ITF!STF $CODE "" \
      [ $? != 0 ] && exit
##########################################################################
NOME=$(echo "$VAR_FORM" | cut -d"|" -f 1)
CARGO=$(echo "$VAR_FORM" | cut -d"|" -f 2)
CODIGO=$(echo "$VAR_FORM" | cut -d"|" -f 3)
LOJA=$(echo "$VAR_FORM" | cut -d"|" -f 4)
CODE=$(echo "$VAR_FORM" | cut -d"|" -f 5)
##########################################################################
 DADOS_USUARIO="<center table border=0><br/>
     <title>Usuário MaxiPOS:$CODIGO</title>
          <a title='Imprimir código' href='javascript:window.print()'><img src='$DIR/img/print.png' border="0" /></a>
         <td><center> - - - - - - - - - - - - - - - - </td></tr>
         <td><center><img --width=60 --height=20 src='$DIR/img/logo_loja/$LOJA.png' /></td></tr>
         <td><center><font size=+2>$NOME</font></td></tr>
         <td><center>$CARGO</td></tr>
         <td><center><img --width=50 --height=15 src='/home/$USER/Imagens/CODIGO.png' /></td></tr>
         <td><center><code>Usuário MaxiPOS:$CODIGO</code></td></tr>
         <td><center> - - - - - - - - - - - - - - - - </td></tr>
      </table>" 
 DADOS_USUARIO1="
         <td><center><img --width=60 --height=20 src='$DIR/img/logo_loja/$LOJA.png' /></td></tr>
         <td><center><font size=+2>$NOME</font></td></tr>
         <td><center>$CARGO</td></tr>
         <td><center><img --width=50 --height=15 src='/home/$USER/Imagens/CODIGO.png' /></td></tr>
         <td><center><code>Usuário MaxiPOS:$CODIGO</code></td></tr>
         <td><center> - - - - - - - - - - - - - - - - </td></tr>
      </table>" 
 DADOS_USUARIO2="
         <td><center><img --width=60 --height=20 src='$DIR/img/logo_loja/$LOJA.png' /></td></tr>
         <td><center><font size=+2>$NOME</font></td></tr>
         <td><center>$CARGO</td></tr>
         <td><center><img --width=50 --height=15 src='/home/$USER/Imagens/CODIGO.png' /></td></tr>
         <td><center><code>Usuário MaxiPOS:$CODIGO</code></td></tr>
         <td><center> - - - - - - - - - - - - - - - - </td></tr>
  <section>
  <p></p>
     <p></p>
        <p></p>
          <p></p>
            <p></p>
          <footer>
       <font size=-8>Dev: Nilsonlinux</font></td></tr>
    </footer>
  </section>
      </table>" 
#########################################################################
# Verificando se o usuario digitou pelo menos o nome
if [ -z $NOME ]
then
# Notificação de erro para gerar codigo
$ERRO | GTK_THEME="Ncode Theme" yad --title="Aviso !"       \
    --center                                    \
    --width=400                                 \
    --height=100                                \
    --image="$DIR/img/erro.svg"                 \
    --fixed                                     \
    --text="Digite pelo menos o nome do colaborador.
    Não foi possível gerar o código!"           \
    --text-align=center                         \
    --button=Fechar
else
  # Enviado dados para um arquivo HTML
$DIR/ncode "0000000$CODIGO" --type EAN13 --file /$HOME/Imagens/CODIGO.png --savespace 1 --xdim 2
echo $DADOS_USUARIO $DADOS_USUARIO1 $DADOS_USUARIO2 > /$HOME/Imagens/codigo.html
##########################################################################
${CONECTADO} | xdg-open /$HOME/Imagens/codigo.html
#.EOF
  # Notificação de sucesso para gerar codigo
  clear # Limpando a tela do terminal
  GTK_THEME="Ncode Theme" yad --title="Parabéns, Código Gerado !"            \
      --center                                       \
      --width=350                                    \
      --height=110                                   \
      --image="$DIR/img/ok.svg"                      \
      --progress-text="Concluido 100%  !"            \
      --percentage=99                                \
      --progress --auto-kill                         \
      --fixed                                        \
      --text-align=center                            \
      --button=Fechar                                \
      --text="Código do(a) $NOME gerado com sucesso.s
      Desenvolvedor: Nilsonlinux"
################################################
fi
################################################
${CLOSE}