unit Model.Email.Interfaces;

interface

const
   EMAILREG = '^([0-9a-zA-Z]([-\.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$';

type
   iModelEmail = interface
      ['{FD148F15-83DC-4700-96AC-0EA2374CD48C}']
      function setServer(host, senha: string): iModelEmail;
      function setEnvio(emailsDestinatarios: TArray<string>; assunto: string): iModelEmail;
      function setMensagem(mensagemASerEnviada: string): iModelEmail;
      function setAnexos(anexos: TArray<string>): iModelEmail;
      function enviar: iModelEmail;
   end;

implementation

end.
