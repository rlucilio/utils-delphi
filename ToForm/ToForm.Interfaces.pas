unit ToForm.Interfaces;

interface


type
  TTipoConversao = (tcText, tcItemIndex, tcChecked, tcDateTime, tcLines);

  TTipoAcaoConversao = (tacSalvar, tacNada);
  iToForm = interface
    ['{4E5ABE29-D750-4167-AE01-28D19EEDE3EF}']
    function ClassToForm(obj: TObject): iToForm;
    function FormToClasse(obj: TObject; acao: TTipoAcaoConversao = tacNada): iToForm;
  end;

implementation



end.
