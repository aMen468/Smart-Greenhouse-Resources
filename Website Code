import gradio as gr

def decode_hex(hex_code):
    hex_code = hex_code.strip().upper()

    # Validate length
    if len(hex_code) != 4:
        return "<div style='color:black;'>Please enter exactly FOUR hex digits (0000–FFFF).</div>"

    # Validate hex format
    try:
        full_value = int(hex_code, 16)
    except:
        return "<div style='color:black;'>Invalid hex input.</div>"

    # Use only the LOWER 8 BITS for decoding
    value = full_value & 0xFF

    # Extract bits from lower byte
    P  = (value >> 7) & 1
    F  = (value >> 6) & 1
    M  = (value >> 5) & 1
    L  = (value >> 4) & 1
    T  = (value >> 3) & 1
    H  = (value >> 2) & 1
    S2 = (value >> 1) & 1
    S1 = value & 1

    def status(label, state, on_text="ON", off_text="OFF"):
        color = "green" if state else "red"
        text = on_text if state else off_text
        return f"<div style='font-size:20px; color:black;'>● <b>{label}</b>: <span style='color:{color}; font-weight:bold;'>{text}</span></div>"

    # 7-segment style display (shows full 4 digits)
    seven_seg_display = f"""
    <div style="
        font-family: monospace;
        font-size: 60px;
        background: black;
        color: red;
        padding: 20px 60px;
        border-radius: 10px;
        text-align:center;
        width: fit-content;
        margin: 20px auto;
        box-shadow: 0px 0px 20px rgba(255,0,0,0.6);
        letter-spacing: 10px;
    ">
        {hex_code}
    </div>
    """

    actuator_section = f"""
    <h2 style='color:white;'>Actuators:</h2>
    {status("💧 Irrigation Pump (P)", P)}
    {status("🌀 Ventilation Fan (F)", F)}
    """

    sensor_section = f"""
    <h2 style='color:white;'>Sensors:</h2>
    {status("🌱 Manual Mode (M)", M, "ACTIVE", "INACTIVE")}
    {status("☀ Light (L)", L, "ACTIVE", "INACTIVE")}
    {status("🌡 Temperature (T)", T, "ACTIVE", "INACTIVE")}
    {status("💨 Humidity (H)", H, "ACTIVE", "INACTIVE")}
    {status("Soil Sensor 2 (S2)", S2, "ACTIVE", "INACTIVE")}
    {status("Soil Sensor 1 (S1)", S1, "ACTIVE", "INACTIVE")}
    """

    binary_display = f"""
    <div style="margin-top:20px; font-size:18px; color:white;">
        <b>Decoded Byte:</b> {format(value, '08b')}
    </div>
    """

    return seven_seg_display + actuator_section + sensor_section + binary_display



custom_css = """
body {
    background-color: black !important;
    color: black !important;
}

.gradio-container {
    background-color: black !important;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

.main-panel {
    max-width: 600px;
    margin: auto;
    text-align: center;
}

textarea, input {
    font-size: 22px !important;
    text-align: center;
}

button {
    font-size: 22px !important;
    padding: 10px 30px !important;
}
"""

with gr.Blocks(css=custom_css) as demo:
    with gr.Column(elem_classes="main-panel"):
        gr.Markdown("<h1 style='font-size:40px;'>ACME inc. Smart Greenhouse Status Decoder</h1>")
        gr.Markdown("<p style='font-size:18px;'></p>")

        hex_input = gr.Textbox(
            label="Status Code (0000–FFFF)",
            max_lines=1
        )

        decode_btn = gr.Button("Decode")

        output = gr.HTML()

        decode_btn.click(decode_hex, inputs=hex_input, outputs=output)

demo.launch(share=True)
