pageextension 50102 MQTT extends "Customer List"
{
    layout
    {

    }

    actions
    {

        addbefore(PaymentRegistration)
        {
            action(MQTT)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    g_MQTT.Run();
                end;
            }
        }
    }

    var
        g_MQTT: Page "MQTT Log";
}