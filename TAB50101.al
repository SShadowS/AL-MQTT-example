table 50101 "MQTT Log"
{
    // version MQTT


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Topic; Text[250])
        {
        }
        field(3; Message; Text[250])
        {
        }
        field(4; "Date Time"; DateTime)
        {
        }
        field(5; BLOBData; BLOB)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

