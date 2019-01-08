unit PersistenciaConfiguracao.Interfaces;

interface

uses
  System.Generics.Collections;

type
  iSalvaCarregaConfiguracao = interface
    ['{22864DF9-E336-473E-AFCC-295E17DA4A51}']
    function getResultado: TDictionary<string, string>;
    function salva(obj: TObject = nil): iSalvaCarregaConfiguracao;
    function carrega(obj: TObject = nil): iSalvaCarregaConfiguracao;
  end;

  iConfiguravel = interface
    ['{49320F75-46E3-4495-BF28-6E91157E9F40}']
    procedure Salvar;
    procedure Carregar;
    function GetConfigurado: boolean;
  end;

implementation

end.
