page 50101 "MQTT Log"
{
    // version MQTT

    PageType = List;
    SourceTable = "MQTT Log";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field(Topic; Topic)
                {
                }
                field(Message; Message)
                {
                }
                field("Date Time"; "Date Time")
                {
                }
            }
        }
    }

    trigger OnInit()
    begin
        g_MQTTMgt.f_Connect;
    end;

    var
        g_MQTTMgt: Codeunit "MQTT Client";
}

