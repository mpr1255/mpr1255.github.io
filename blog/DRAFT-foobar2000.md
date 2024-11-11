# How to enable play/pause on foobar2000 on Mac with spacebar

Found on reddit and it absolutely needs re-upping.

foobar2000 is the best music listening app since forever, but in Mac it lacks keyboard shortcuts =(

One can hack a few together using Karabinder. To add this, go to Complex Modification -> Add your own rule, and copypasta.

```json
{
"description": "Use spacebar in foobar2000",
"manipulators": [
    {
        "conditions": [
            {
                "bundle_identifiers": [
                    "^com.foobar2000.mac"
                ],
                "type": "frontmost_application_if"
            }
        ],
        "from": {
            "key_code": "spacebar"
        },
        "to": [
            {
                "key_code": "play_or_pause"
            }
        ],
        "type": "basic"
    }
]
}
```