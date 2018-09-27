unit Model.Email;

interface

uses Model.Email.Interfaces, IdSMTP, IdSSLOpenSSL, IdMessage, IdText,
   IdAttachmentFile,
   IdExplicitTLSClientServerBase, System.RegularExpressions, System.threading,
   System.Classes;

type
   TModelEmail = class(TInterfacedObject, iModelEmail)
   private
      SSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
      SMTP: TIdSMTP;
      Mensagem: TIdMessage;
      Texto: TIdText;
      FemailRemetente: string;
      FnomeRemetente: string;
      constructor Create(emailRemetente, nomeRemetente: string);
   public
      class function New(emailRemetente, nomeRemetente: string): iModelEmail;
      destructor Destroy; override;
      function setServer(host, senha: string): iModelEmail;
      function validaEmail(Email: string): boolean;
      function setEnvio(emailsDestinatarios: TArray<string>; assunto: string)
        : iModelEmail;
      function setMensagem(mensagemASerEnviada: string): iModelEmail;
      function setAnexos(anexos: TArray<string>): iModelEmail;
      function enviar: iModelEmail;
      property emailRemetente: string read FemailRemetente;
      property nomeRemetente: string read FnomeRemetente;

   end;

implementation

uses
   System.SysUtils;

{ TModelEmail }

function TModelEmail.setMensagem(mensagemASerEnviada: string): iModelEmail;
begin
   result := self;
   Texto := TIdText.Create(Mensagem.MessageParts);
   Texto.Body.Add(mensagemASerEnviada);
   Texto.ContentType := 'text/plain; charset=iso-8859-1';
end;

function TModelEmail.setServer(host, senha: string): iModelEmail;
begin
   result := self;
   SSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
   SSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

   SMTP.IOHandler := SSLIOHandlerSocket;
   SMTP.UseTLS := utUseImplicitTLS;
   SMTP.AuthType := satDefault;
   SMTP.Port := 465;
   SMTP.host := host;
   SMTP.Username := emailRemetente;
   SMTP.Password := senha;
end;

constructor TModelEmail.Create(emailRemetente, nomeRemetente: string);
begin
   inherited Create;
   SSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
   SMTP := TIdSMTP.Create(nil);
   Mensagem := TIdMessage.Create(nil);

   if nomeRemetente.IsEmpty then
      raise Exception.Create('Nome do remetende é inválido')
   else
      FnomeRemetente := nomeRemetente;

   if validaEmail(emailRemetente) then
      FemailRemetente := emailRemetente
   else
      raise Exception.Create('Email do remetende é inválido');
end;

destructor TModelEmail.Destroy;
begin
   FreeAndNil(SSLIOHandlerSocket);
   FreeAndNil(SMTP);
   FreeAndNil(Mensagem);
   UnLoadOpenSSLLibrary;
   inherited;
end;

function TModelEmail.enviar: iModelEmail;

begin
   result := self;
  try

      try
         SMTP.Connect;
         SMTP.Authenticate;
      except
        abort;
      end;

      try
         SMTP.Send(Mensagem);
      except
        abort;
      end;

      SMTP.Send(Mensagem);
   finally
      SMTP.Disconnect();
   end;


end;

function TModelEmail.setAnexos(anexos: TArray<string>): iModelEmail;
var
   anexo: string;
begin
   result := self;

   for anexo in anexos do
   begin
      if FileExists(anexo) then
         TIdAttachmentFile.Create(Mensagem.MessageParts, anexo);
   end;

end;

function TModelEmail.setEnvio(emailsDestinatarios: TArray<string>;
  assunto: string): iModelEmail;
var
   Email: string;
begin
   result := self;

   Mensagem.From.Address := emailRemetente;
   Mensagem.From.Name := nomeRemetente;
   Mensagem.ReplyTo.EMailAddresses := Mensagem.From.Address;

   for Email in emailsDestinatarios do
   begin
      if validaEmail(Email) then
         Mensagem.Recipients.Add.Text := Email;
   end;

   Mensagem.Subject := assunto;
   Mensagem.Encoding := meMIME;
end;

class function TModelEmail.New(emailRemetente, nomeRemetente: string)
  : iModelEmail;
begin
   result := self.Create(emailRemetente, nomeRemetente);
end;

function TModelEmail.validaEmail(Email: string): boolean;
begin
   result := TRegEx.IsMatch(Email, EMAILREG);

end;

end.
