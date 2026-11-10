Unit Unit1;

interface

uses System, System.Drawing, System.Windows.Forms,
     SlimDX, SlimDx.Direct3D9;

type
  Form1 = class(Form)
    procedure Form1_Load(sender: Object; e: EventArgs);
    procedure Form1_FormClosing(sender: Object; e: FormClosingEventArgs);
    procedure Form1_Paint(sender: Object; e: PaintEventArgs);
    procedure Form1_Resize(sender: Object; e: EventArgs);
  {$region FormDesigner}
  internal
    {$resource Unit1.Form1.resources}
    {$include Unit1.Form1.inc}
  {$endregion FormDesigner}
  public
    constructor;
    begin
      InitializeComponent;
    end;
  private
    m_oD3D: Direct3D;
    m_oD3D_Device: Device;
    m_d3dpp: PresentParameters;
    function InitializeDirect3D():boolean;
    procedure DestroyDirect3D();
    procedure RenderScene();
  end;

implementation

procedure Form1.Form1_Load(sender: Object; e: EventArgs);
begin
  if(not InitializeDirect3D()) then
  begin          
    MessageBox.Show('Failed Loading DirectX', 'Error');
    Application.Exit();
    exit;
  end;          
  SetStyle(ControlStyles.Opaque, true);
  SetStyle(ControlStyles.ResizeRedraw, true); 
end;

procedure Form1.Form1_FormClosing(sender: Object; e: FormClosingEventArgs);
begin
  DestroyDirect3D(); 
end;

procedure Form1.Form1_Paint(sender: Object; e: PaintEventArgs);
begin
  RenderScene();  
end;

procedure Form1.Form1_Resize(sender: Object; e: EventArgs);
begin
  if ( m_oD3D = nil ) then exit;
  if ( m_oD3D_Device = nil ) then exit;
  if (ClientSize.Width > 0) and (ClientSize.Height > 0) then
  begin
    m_d3dpp.BackBufferWidth := ClientSize.Width;
    m_d3dpp.BackBufferHeight := ClientSize.Height;
    m_oD3D_Device.Reset(m_d3dpp);  
  end;
  Invalidate();
end;

function Form1.InitializeDirect3D():boolean;
var
  bResult:boolean;
begin
  bResult := false;
  m_d3dpp := new PresentParameters();
  m_d3dpp.SwapEffect := SwapEffect.Discard;
  m_d3dpp.Windowed := true;
  m_d3dpp.EnableAutoDepthStencil := false;
  m_d3dpp.BackBufferWidth := ClientSize.Width;
  m_d3dpp.BackBufferHeight := ClientSize.Height;
  try
    m_oD3D := new Direct3D();
    var nAdapter := m_oD3D.Adapters.DefaultAdapter.Adapter;
    var d3ddm := m_oD3D.GetAdapterDisplayMode(nAdapter);
    m_d3dpp.BackBufferFormat := d3ddm.Format;
    m_oD3D_Device := new Device
    (
      m_oD3D, nAdapter,
      DeviceType.Hardware, 
      Handle,
      CreateFlags.SoftwareVertexProcessing,
      m_d3dpp
    );
    bResult := m_oD3D_Device <> nil;
  except
    bResult := false;
  end;
  Result := bResult;
end;

procedure Form1.DestroyDirect3D();
begin
  if ( m_oD3D_Device <> nil ) then
    m_oD3D_Device.Dispose();
  if ( m_oD3D <> nil ) then
    m_oD3D.Dispose();
end;

procedure Form1.RenderScene();
begin
  var width := Convert.ToInt32(ClientSize.Width / 8);
  var height := Convert.ToInt32(ClientSize.Height / 8);
  var d3dColor1 := new Color4(Color.Aqua);
  var d3dColor2 := new Color4(Color.Brown);
  var rects := new Rectangle[32];
  if ( m_oD3D = nil ) then exit;
  if ( m_oD3D_Device = nil ) then exit;
  var d3dResult := m_oD3D_Device.TestCooperativeLevel();
  if (d3dResult = ResultCode.DeviceLost) then exit;
  if (d3dResult = ResultCode.DeviceNotReset) then
  begin
    m_oD3D_Device.Reset(m_d3dpp);
    Invalidate();
  end;
  m_oD3D_Device.Clear(ClearFlags.Target, d3dColor1, 0.0, 0);
  for var k : integer := 0 to 31 do
  begin
    var i : Integer = k div 4;
    var j : Integer = (k mod 4) * 2 + (i Mod 2);
    var Left : Integer = i * Width;
    var Top : Integer = j * Height;
    rects[k] := New Rectangle(Left, Top, Width, Height);
  end;
  m_oD3D_Device.Clear(ClearFlags.Target, d3dColor2, 0.0, 0, rects);
  m_oD3D_Device.BeginScene();
  m_oD3D_Device.EndScene();
  m_oD3D_Device.Present();
end;


end.
