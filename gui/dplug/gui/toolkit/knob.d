module dplug.gui.toolkit.knob;

import std.math;
import dplug.gui.toolkit.element;

class UIKnob : UIElement
{
public:

    this(UIContext context, Font font, string label)
    {
        super(context);
        _label = label;
        _font = font;
        _value = 0.5f;
    }

    override void onDraw(ImageRef!RGBA surface)
    {
        auto c = RGBA(80, 80, 80, 255);

        if (isMouseOver())
            c = RGBA(100, 100, 120, 255);

        if (isDragged())
            c = RGBA(150, 150, 80, 255);

        int centerx = _position.center.x;
        int centery = _position.center.y;
        int radius = _position.width / 2;
        int radius2 = 0;
        float angle = (_value - 0.5f) * 4.0f;
        float posEdgeX = centerx + sin(angle) * radius;
        float posEdgeY = centery - cos(angle) * radius;
        float posEdgeX2 = centerx + sin(angle) * radius2;
        float posEdgeY2 = centery - cos(angle) * radius2;

        surface.softCircle(centerx, centery, radius - 2, radius, c);
        surface.aaLine(posEdgeX, posEdgeY, posEdgeX2, posEdgeY2, RGBA(0,0, 0, 0));

        _font.size = 16;
        _font.color = RGBA(220, 220, 220, 255);
        _font.fillText(surface, _label, _position.center.x, _position.max.y + 20);
    }

    override bool onMousePreClick(int x, int y, int button, bool isDoubleClick)
    {
        setDirty();
        return true; // to initiate dragging
    }

    // Called when mouse drag this Element.
    override void onMouseDrag(int x, int y, int dx, int dy)
    {
        setDirty();
        _value = clamp(_value - dy * 0.003f, 0.0f, 1.0f);
        onValueChanged();
    }

    // override to set the parameter host-side
    void onValueChanged()
    {
    }

    // For lazy updates
    override void onBeginDrag()
    {
        setDirty();
    }

    override  void onStopDrag()
    {
        setDirty();
    }

    override void onMouseEnter()
    {
        setDirty();
    }

    override void onMouseExit()
    {
        setDirty();
    }

protected:
    string _label;
    Font _font;
    float _value; // between 0 and 1
}
