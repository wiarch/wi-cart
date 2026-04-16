# Design System Document: Fresh & Organized Editorial

## 1. Overview & Creative North Star: "The Botanical Editor"
The Creative North Star for this design system is **"The Botanical Editor."** We are moving away from the "utility-first" look of standard grocery apps and toward a high-end, editorial experience that feels as fresh as a farmer's market find. 

The system rejects the rigid, boxed-in layouts of traditional mobile apps. Instead, it utilizes **intentional asymmetry**, large-scale typography for category headers, and **organic layering**. By treating the mobile screen like a premium lifestyle magazine, we transform a mundane chore into a curated ritual. Depth is not created with lines, but through a "Paper-on-Stone" philosophy—stacking soft, organic surfaces to create a tactile, breathable environment.

---

## 2. Colors & Tonal Depth
Our palette is rooted in the `primary` (#006b1b) "Leaf Green," but its premium feel comes from how it interacts with our neutrals.

### The "No-Line" Rule
**Prohibit 1px solid borders for sectioning.** To separate a product category from the main list, do not draw a line. Instead, shift the background from `surface` (#f5f7f5) to `surface-container-low` (#eff1ef). Boundaries are felt, not seen.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack.
*   **Base:** `surface` (#f5f7f5) for the main application background.
*   **Sections:** `surface-container-low` (#eff1ef) for grouping related items (e.g., the "Produce" aisle group).
*   **Cards/Items:** `surface-container-lowest` (#ffffff) for individual product cards to provide maximum "pop" and perceived cleanliness.

### The "Glass & Gradient" Rule
For floating action buttons or active currency toggles, use a subtle linear gradient from `primary` (#006b1b) to `primary_dim` (#005d16). For overlays (like a "Add Item" modal), use a **Glassmorphism** effect: `surface` at 80% opacity with a 20px backdrop-blur. This keeps the "freshness" by letting the vibrant greens of the list bleed through.

---

## 3. Typography: The Editorial Voice
We use **Inter** as our typographic engine. To achieve the "Botanical Editor" look, use extreme contrast in scale.

*   **Display-LG (3.5rem):** Used for empty state inspiration or total budget summaries.
*   **Headline-SM (1.5rem):** For category names (e.g., "Dairy & Eggs"). Use high-contrast `on_surface` (#2c2f2e).
*   **Title-MD (1.125rem):** For product names. This is the "hero" of the list item.
*   **Label-MD (0.75rem):** For price tags and unit measurements.
*   **Body-SM (0.75rem):** For secondary metadata like "Added 2 days ago."

**Editorial Note:** Use `on_surface_variant` (#595c5b) for secondary info to ensure the product names remain the primary visual focus.

---

## 4. Elevation & Depth
We eschew "Material" shadows in favor of **Tonal Layering** and **Ambient Glows.**

*   **The Layering Principle:** A list item (`surface-container-lowest`) sitting on a category background (`surface-container-low`) creates a natural 3D lift without a single drop shadow.
*   **Ambient Shadows:** If an element must float (like the "Total" bar), use a shadow with a 32px blur, 0px offset, and 6% opacity of the `on_surface` color. It should look like a soft glow, not a hard shadow.
*   **The "Ghost Border" Fallback:** If a product image requires a container, use `outline_variant` at 15% opacity. Never use 100% opaque outlines.
*   **Glassmorphism:** Use for "Sticky" headers. As the user scrolls, the vibrant greens of the checkable items should blur beautifully behind the category title.

---

## 5. Components

### Checkable List Items
*   **State - Unchecked:** A `surface-container-lowest` card with `md` (12px) rounded corners. The checkbox is a "Ghost Border" circle.
*   **State - Checked:** The card background shifts to `surface-dim` (#d1d5d3). Typography should use `on_surface_variant` with a subtle strikethrough. The checkbox fills with `primary` (#006b1b) and a white check icon.
*   **Layout:** No dividers. Use 8px of vertical spacing between items.

### Price Tags & Currency Toggles
*   **Price Tags:** Small pills using `secondary_container` (#86faac) with `on_secondary_container` (#005f32) text.
*   **Currency Toggles:** A "segmented control" style where the active state is a `primary` pill. Use `md` (12px) rounding for the container to match the overall system language.

### Buttons
*   **Primary Action (Add Item):** A signature floating element. Use the "Leaf Green" gradient with an `xl` (1.5rem) corner radius for a "pill" feel.
*   **Tertiary (Edit/Clear):** Pure text buttons using `primary` color. No background, no border.

### Search Bar
*   Avoid the "box in a box" look. The search bar should be a `surface-container-high` (#e0e3e1) field that spans the full width of the screen, blending into the header.

---

## 6. Do's and Don'ts

### Do
*   **Do** use white space as a structural element. If a screen feels cluttered, increase the padding rather than adding a border.
*   **Do** use asymmetrical padding. A category title can have a larger left-margin than the list items below it to create an editorial "ragged" look.
*   **Do** ensure accessibility. While we use tonal shifts, ensure the contrast between `on_surface` and `surface` meets WCAG AA standards.

### Don't
*   **Don't** use 1px dividers between list items. Use the spacing scale (`0.75rem` or `1rem`) to separate them.
*   **Don't** use "Alert Red" for everything negative. Use `error` (#b02500) sparingly for critical deletes; for "Out of Stock," use `on_surface_variant` to keep the UI calm.
*   **Don't** use sharp corners. The `md` (12px) radius is our signature; it communicates the "Organic" part of the North Star.