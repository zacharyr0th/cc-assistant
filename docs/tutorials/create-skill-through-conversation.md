# Creating Skills with Claude Through Conversation

## Overview

Claude allows users to teach it specific workflows through Skills. The conversational approach makes this accessible to anyone, regardless of technical background, as an alternative to writing skill files manually.

## Five-Step Process

**1. Enable the Skill-Creator Skill**
Navigate to Settings > Capabilities > Skills and activate "skill-creator," which enables Claude to build properly formatted skills.

**2. Start a Conversation**
Open a new chat describing your desired skill, such as "I want to create a skill for quarterly business reviews." Upload any relevant materials—templates, examples, brand guidelines, or data files—that demonstrate your approach.

**3. Answer Claude's Questions**
Claude asks about your process and usage scenarios. Provide sufficient detail so someone unfamiliar with your work could follow your methodology.

**4. Claude Builds the Skill**
Claude creates a SKILL.md instruction file, organizes your materials, generates necessary code, and packages everything into a ZIP file.

**5. Activate and Test**
Download the ZIP file and upload it in Settings > Capabilities > Skills. Test the skill in new conversations, observing whether Claude recognizes when to use it. Refine as needed by requesting adjustments in the original conversation.

## Skill Components

Skills bundle three content types:

- **Instructions**: A SKILL.md file explaining your process
- **Reference Materials**: Brand assets, templates, data files, or reference documents
- **Scripts**: Executable code for data work, document processing, integrations, or media processing

## Examples of Skills You Can Build

- CRM automation
- Legal contract review
- Sprint planning
- SEO content optimization
- Report automation
- Skill reviewer evaluation

## Best Practices

- Provide concrete examples when describing your workflow
- Upload actual templates or documents you use
- Be specific about when the skill should be invoked
- Test the skill in realistic scenarios
- Iterate based on performance in new conversations
