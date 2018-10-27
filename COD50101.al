codeunit 50101 "MQTT Client"
{
    // version MQTT

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        [WithEvents]
        g_M2MqttClient: DotNet MqttClient;
        g_StatusCode: Integer;
        g_ArrayString: DotNet Array;
        g_ArrayByte: DotNet Array;
        g_String: Text;
        g_Byte: Byte;

    procedure f_Connect()
    begin
        //MQTT server
        g_M2MqttClient := g_M2MqttClient.MqttClient('192.168.2.73');

        //Your client ID on server
        g_StatusCode := g_M2MqttClient.Connect('NAVClient');

        //Array of Topics to subscribe to
        g_ArrayString := g_ArrayString.CreateInstance(GETDOTNETTYPE(g_String), 4);
        g_ArrayString.SetValue('/NAV/Char2Char', 0);
        g_ArrayString.SetValue('/NAV/StringUTF8', 1);
        g_ArrayString.SetValue('/NAV/StringUnicode', 2);
        g_ArrayString.SetValue('/NAV/Blob', 3);

        //Array of QoS Levels to use
        g_ArrayByte := g_ArrayByte.CreateInstance(GETDOTNETTYPE(g_Byte), 4);
        g_Byte := 0;
        g_ArrayByte.SetValue(g_Byte, 0);
        g_ArrayByte.SetValue(g_Byte, 1);
        g_ArrayByte.SetValue(g_Byte, 2);
        g_ArrayByte.SetValue(g_Byte, 3);

        //Subscribe to Topics
        g_M2MqttClient.Subscribe(g_ArrayString, g_ArrayByte);
    end;

    local procedure f_ImportCharByChar(sender: Variant; e: DotNet MqttMsgPublishEventArgs): Text
    var
        l_Array: DotNet Array;
        l_Char: Char;
        l_Text: Text;
    begin
        //Directly convert array of bytes to string.
        l_Array := e.Message();
        FOREACH l_Char IN l_Array DO
            l_Text := l_Text + FORMAT(l_Char);

        EXIT(l_Text);
    end;

    local procedure f_ImportStringUTF8(sender: Variant; e: DotNet MqttMsgPublishEventArgs): Text
    var
        l_Array: DotNet Array;
        l_Text: Text;
        l_Encoding: DotNet Encoding;
    begin
        //Convert UTF8 encoded array of bytes to string.
        l_Array := e.Message();
        l_Text := l_Encoding.UTF8.GetString(l_Array);

        EXIT(l_Text);
    end;

    local procedure f_ImportStringUnicode(sender: Variant; e: DotNet MqttMsgPublishEventArgs): Text
    var
        l_Array: DotNet Array;
        l_Text: Text;
        l_Encoding: DotNet Encoding;
    begin
        //Convert UTF8 encoded array of bytes to string.
        l_Array := e.Message();
        l_Text := l_Encoding.Unicode.GetString(l_Array);

        EXIT(l_Text);
    end;

    local procedure f_ImportBlob(sender: Variant; e: DotNet MqttMsgPublishEventArgs; var p_MQTTLog: Record "MQTT Log"): Text
    var
        l_Array: DotNet Array;
        l_Text: Text;
        l_MemoryStream: DotNet MemoryStream;
        l_OutStream: OutStream;
        l_Encoding: DotNet Encoding;
    begin
        //Presumes a BASE64
        l_Array := e.Message();
        l_MemoryStream := l_MemoryStream.MemoryStream(e.Message);
        l_Text := l_Encoding.UTF8.GetString(l_Array);
        p_MQTTLog.BLOBData.CREATEOUTSTREAM(l_OutStream);
        l_MemoryStream.CopyTo(l_OutStream);
        l_Text := 'Blob Data, size: ' + FORMAT(l_MemoryStream.Length);

        EXIT(l_Text);
    end;

    trigger g_M2MqttClient::MqttMsgPublishReceived(sender: Variant; e: DotNet MqttMsgPublishEventArgs)
    var
        l_MQTTLog: Record "MQTT Log";
    begin
        l_MQTTLog.INIT;
        l_MQTTLog.Topic := e.Topic;
        CASE l_MQTTLog.Topic OF
            '/NAV/Char2Char':
                l_MQTTLog.Message := f_ImportCharByChar(sender, e);

            '/NAV/StringUTF8':
                l_MQTTLog.Message := f_ImportStringUTF8(sender, e);

            '/NAV/StringUnicode':
                l_MQTTLog.Message := f_ImportStringUnicode(sender, e);

            '/NAV/Blob':
                l_MQTTLog.Message := f_ImportBlob(sender, e, l_MQTTLog);

            ELSE
                EXIT;
        END;
        l_MQTTLog."Date Time" := CURRENTDATETIME;
        l_MQTTLog.INSERT;
    end;

    trigger g_M2MqttClient::MqttMsgPublished(sender: Variant; e: DotNet MqttMsgPublishedEventArgs)
    begin
    end;

    trigger g_M2MqttClient::MqttMsgSubscribed(sender: Variant; e: DotNet MqttMsgSubscribedEventArgs)
    begin
    end;

    trigger g_M2MqttClient::MqttMsgUnsubscribed(sender: Variant; e: DotNet MqttMsgUnsubscribedEventArgs)
    begin
    end;

    trigger g_M2MqttClient::ConnectionClosed(sender: Variant; e: DotNet EventArgs)
    begin
    end;
}

