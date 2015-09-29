## Scale Vertical Spacing

This snippet provides an easier way to adjust vertical spacing by letting you scale the default vertical spacing settings.  It provides two functions:

* `scaleVerticalSpacingPageLayout` -- for scaling page layout variables that affect vertical spacing outside of systems (see [docs](http://lilypond.org/doc/v2.18/Documentation/notation/flexible-vertical-spacing-paper-variables)). Basically like using a paper block to set new values for these variables.

* `scaleVerticalSpacingInSystems` -- for scaling context properties and grob properties that affect vertical spacing within musical systems (see [docs](http://lilypond.org/doc/v2.18/Documentation/notation/flexible-vertical-spacing-within-systems)). Returns a layout block that sets new values for these properties. 

These functions should be placed at the top level of a file (where layout blocks and paper blocks go).

They take a single argument.  The argument can simply be a number, which is then used to scale _all_ applicable vertical spacing properties by that amount. 

    \scaleVerticalSpacingPageLayout #1.5
    \scaleVerticalSpacingInSystems #1.4

This may be sufficient in some cases, but for more control and flexibility the argument can be a "list of lists" that specifies different scaling values for different items.

    % scale specific page layout variables by specific amounts
    
    \scaleVerticalSpacingPageLayout
    #'((all 1.1)
       (system-system-spacing 1.2)
       (score-system-spacing 1.3)
       (markup-system-spacing 1.2)
       (score-markup-spacing 1.3)
       (markup-markup-spacing 1.2)
       (top-system-spacing 1.3)
       (top-markup-spacing 1.2)
       (last-bottom-spacing 1.3))

    % scale the properties of specific contexts (and/or properties of the StaffGrouper grob, which is not a context)
    
    \scaleVerticalSpacingInSystems
    #'((all 1.1)
       (StaffGrouper 1.2)
       (ChordNames 1.3)
       (Dynamics 1.2)
       (FiguredBass 1.3)
       (Lyrics 1.2)
       (NoteNames 1.3)
       (Staff 1.2)
       (DrumStaff 1.3)
       (GregorianTranscriptionStaff 1.2)
       (KievanStaff 1.3)
       (MensuralStaff 1.2)
       (PetrucciStaff 1.3)
       (RhythmicStaff 1.2)
       (TabStaff 1.3)
       (VaticanaStaff 1))

The value for `all` sets the scaling factor for all of the different items (just like providing a single number as an argument).  The value for all is replaced by any more specific settings.  For example:

    \scaleVerticalSpacingInSystems
    #'((all 1.4)
       (StaffGrouper 1)
       (Lyrics 1.2))

This keeps the default StaffGrouper spacing, but scales everything else by 1.4, except for Lyrics, which is scaled by 1.2.

With `scaleVerticalSpacingInSystems` you can get even more detailed and specify different scaling factors for specific context properties:

    % scale specific properties within specific contexts (and/or of the StaffGrouper grob, which is not a context)
    
    \scaleVerticalSpacingInSystems
    #'((all 1)
       (StaffGrouper staff-staff-spacing 1)
       (StaffGrouper staffgroup-staff-spacing 1)
       (ChordNames nonstaff-relatedstaff-spacing 1)
       (ChordNames nonstaff-nonstaff-spacing 1)
       (FiguredBass nonstaff-relatedstaff-spacing 1)
       (FiguredBass nonstaff-nonstaff-spacing 1)
       (Lyrics nonstaff-relatedstaff-spacing 1)
       (Lyrics nonstaff-nonstaff-spacing 1)
       (Lyrics nonstaff-unrelatedstaff-spacing 1)
       (NoteNames nonstaff-relatedstaff-spacing 1)
       (NoteNames nonstaff-nonstaff-spacing 1)
       (NoteNames nonstaff-unrelatedstaff-spacing 1))


Again, more specific settings trump more general settings.  The following will scale everything by 1.5, except for lyrics context properties which will be scaled by 1.3, except for the `Lyrics nonstaff-nonstaff-spacing` property, which will not be scaled at all.

    \scaleVerticalSpacingInSystems
    #'((all 1.5)
       (Lyrics 1.3)
       (Lyrics nonstaff-nonstaff-spacing 1))

Items that have only a single propery to scale (i.e. Dynamics, Staff, DrumStaff, and all other staff types...) are not shown above, because:

    (Dynamics nonstaff-relatedstaff-spacing 1)
    (Staff default-staff-staff-spacing 1)
    (DrumStaff default-staff-staff-spacing 1)

is the same as 

    (Dynamics 1)
    (Staff 1)
    (DrumStaff 1)

(Either will work, but clearly the shorter versions are simpler.)


### Background

The process for adjusting vertical spacing in LilyPond can be challenging.  

1. You have to identify which properties need to be adjusted. (e.g. do I override `StaffGrouper.staff-staff-spacing` or `StaffGrouper.staffgroup-staff-spacing`?)
2. Each property has three properties of its own, so you have to decide which one of those to change (e.g. do I change `basic-distance`, `minimum-distance`, or `padding`?)
3. If you want to know the default values for these settings, in order to be aware of how much you are changing them, you have to look each one up in the internals reference.

This snippet simplifies this process.  It is much simpler to scale the default values, rather than looking them up in different places or making a guess at what a good value might be. 

You also don't have to decide whether to adjust `basic-distance`, `minimum-distance`, or `padding`, since these functions scale all three of them together, maintaining the proportions between them. This way you are more likely to arrive at a good result than picking one and changing it in isolation (unless you _really_ know what you are doing).

Finally, it lets you be as detailed and specific as you want: 

* You can adjust all vertical spacing settings with a single scaling factor when that is sufficient.
* You can provide different scaling factors for different items to adjust all the relevant properties for those items. 
* For items with more than one property that affects vertical spacing, you can specify different scaling factors for each of those properties.

### Suggested Use

Work from general to specific.  Start by adjusting vertical spacing in general, then get more specific if certain items need more or less spacing.

### Disclaimer

These functions do not guarantee good spacing for all values you could feed them, nor do they try to do that. They aim to improve upon the usual process for adjusting vertical spacing. They make it easier to do, and should make it more likely that you will arrive at good results.

In other words, they are not meant to provide a "smart" high-level algorithm that always gets the spacing right by deciding for you how much to scale one thing vs another. They are meant as lower-level dumb/simple/transparent tools that make it easier for you to adjust vertical spacing as you see fit.

### Appendix: Default Settings

You don't need to know these, but here they are for reference.  All the various staff types have the same settings as `Staff`.

<table>
    <tr>
        <th>Page Layout Variables</th>
        <th>basic-distance</th>
        <th>minimum-distance</th>
        <th>padding</th>
    </tr>
    <tr>
        <td>system-system-spacing</td>
        <td>12</td>
        <td>8</td>
        <td>1</td>
    </tr>
    <tr>
        <td>score-system-spacing</td>
        <td>14</td>
        <td>8</td>
        <td>1</td>
    </tr>
    <tr>
        <td>markup-system-spacing</td>
        <td>5</td>
        <td>0</td>
        <td>0.5</td>
    </tr>
    <tr>
        <td>score-markup-spacing</td>
        <td>12</td>
        <td>0</td>
        <td>0.5</td>
    </tr>
    <tr>
        <td>markup-markup-spacing</td>
        <td>1</td>
        <td>0</td>
        <td>0.5</td>
    </tr>
    <tr>
        <td>top-system-spacing</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
    </tr>
    <tr>
        <td>top-markup-spacing</td>
        <td>0</td>
        <td>0</td>
        <td>1</td>
    </tr>
    <tr>
        <td>last-bottom-spacing</td>
        <td>1</td>
        <td>0</td>
        <td>1</td>
    </tr>
</table>

<table>
    <tr>
        <th>In-System Context and Grob Properties</th>
        <th>basic-distance</th>
        <th>minimum-distance</th>
        <th>padding</th>
    </tr>
    <tr>
        <td>StaffGrouper.staff-staff-spacing</td>
        <td>9</td>
        <td>7</td>
        <td>1</td>
    </tr>
    <tr>
        <td>StaffGrouper.staffgroup-staff-spacing</td>
        <td>10.5</td>
        <td>8</td>
        <td>1</td>
    </tr>
    <tr>
        <td>Staff VerticalAxisGroup.default-staff-staff-spacing</td>
        <td>9</td>
        <td>8</td>
        <td>1</td>
    </tr>
    <tr>
        <td>ChordNames VerticalAxisGroup.nonstaff-relatedstaff-spacing</td>
        <td>0</td>
        <td>0</td>
        <td>0.5</td>
    </tr>
    <tr>
        <td>ChordNames VerticalAxisGroup.nonstaff-nonstaff-spacing</td>
        <td>0</td>
        <td>0</td>
        <td>0.5</td>
    </tr>
    <tr>
        <td>Dynamics VerticalAxisGroup.nonstaff-relatedstaff-spacing</td>
        <td>5</td>
        <td>0</td>
        <td>0.5</td>
    </tr>
    <tr>
        <td>FiguredBass VerticalAxisGroup.nonstaff-relatedstaff-spacing</td>
        <td>0</td>
        <td>0</td>
        <td>0.5</td>
    </tr>
    <tr>
        <td>FiguredBass VerticalAxisGroup.nonstaff-nonstaff-spacing</td>
        <td>0</td>
        <td>0</td>
        <td>0.5</td>
    </tr>
    <tr>
        <td>Lyrics VerticalAxisGroup.nonstaff-relatedstaff-spacing</td>
        <td>5.5</td>
        <td>0</td>
        <td>0.5</td>
    </tr>
    <tr>
        <td>Lyrics VerticalAxisGroup.nonstaff-nonstaff-spacing</td>
        <td>0</td>
        <td>2.8</td>
        <td>0.2</td>
    </tr>
    <tr>
        <td>Lyrics VerticalAxisGroup.nonstaff-unrelatedstaff-spacing</td>
        <td>0</td>
        <td>0</td>
        <td>1.5</td>
    </tr>
    <tr>
        <td>NoteNames VerticalAxisGroup.nonstaff-relatedstaff-spacing</td>
        <td>5.5</td>
        <td>0</td>
        <td>0.5</td>
    </tr>
    <tr>
        <td>NoteNames VerticalAxisGroup.nonstaff-nonstaff-spacing</td>
        <td>0</td>
        <td>2.8</td>
        <td>0.2</td>
    </tr>
    <tr>
        <td>NoteNames VerticalAxisGroup.nonstaff-unrelatedstaff-spacing</td>
        <td>0</td>
        <td>0</td>
        <td>1.5</td>
    </tr>
</table>
            