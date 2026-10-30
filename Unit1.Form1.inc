procedure InitializeComponent;
    begin
        self.SuspendLayout();
        // 
        // Form1
        // 
        self.ClientSize := new System.Drawing.Size(824, 468);
        self.Name := 'Form1';
        self.StartPosition := System.Windows.Forms.FormStartPosition.CenterScreen;
        self.Text := 'ChessBoard';
        self.FormClosing += Form1_FormClosing;
        self.Load += Form1_Load;
        self.Paint += Form1_Paint;
        self.Resize += Form1_Resize;
        self.ResumeLayout(false);
    end;
