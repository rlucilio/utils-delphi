unit Factory.PersistenciaConfigucao;

interface

uses
  PersistenciaConfiguracao.Interfaces, PersistenciaConfiguracao.Ini;

type
  TTipoPersistenciaConfiguracao = (tpcIni);

  TFactoryPersistenciaConfiguracao = class(TObject)
  public
    class function getPersistenciaConfiguracao(tipoPersistencia
      : TTipoPersistenciaConfiguracao): iSalvaCarregaConfiguracao;
  end;

implementation

{ TFactoryPersistenciaConfiguracao }

class function TFactoryPersistenciaConfiguracao.getPersistenciaConfiguracao
  (tipoPersistencia: TTipoPersistenciaConfiguracao): iSalvaCarregaConfiguracao;
begin
  case tipoPersistencia of
    tpcIni:
      result := TPersistenciaIni.New;

  end;
end;

end.
