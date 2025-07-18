import { Button, Input, LabeledList, Section } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const TOOLTIP_NAME = `
  Enter a new name for this unit. Set to blank to reset to default,
  which means unit will be able to choose it's own name.
`;

const TOOLTIP_LOCOMOTION = `
  If restricted, unit will be
  under lockdown until released.
`;

const TOOLTIP_PANEL = `
  If unlocked, unit's cover panel will be
  accessible even without proper authorization.
`;

const TOOLTIP_AISYNC = `
  If closed, this unit will
  not be paired with any AI.
`;

const TOOLTIP_AI = `
  Controls who will be the
  master AI of this unit.
`;

const TOOLTIP_LAWSYNC = `
  If closed, this unit will not synchronize
  it's laws with it's master AI.
`;

export const CyborgBootDebug = (props) => {
  const { act, data } = useBackend();
  const { designation, master, lawsync, aisync, locomotion, panel } = data;
  return (
    <Window width={master?.length > 26 ? 537 : 440} height={289}>
      <Window.Content>
        <Section title="Basic Settings">
          <LabeledList>
            <LabeledList.Item
              label="Designation"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_NAME}
                  tooltipPosition="left"
                />
              }
            >
              <Input
                fluid
                value={designation || 'Default Cyborg'}
                onChange={(e, value) =>
                  act('rename', {
                    new_name: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="Servo Motor Functions"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_LOCOMOTION}
                  tooltipPosition="left"
                />
              }
            >
              <Button
                icon={locomotion ? 'unlock' : 'lock'}
                content={locomotion ? 'Free' : 'Restricted'}
                color={locomotion ? 'good' : 'bad'}
                onClick={() => act('locomotion')}
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="Cover Panel"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_PANEL}
                  tooltipPosition="left"
                />
              }
            >
              <Button
                icon={panel ? 'lock' : 'unlock'}
                content={panel ? 'Locked' : 'Unlocked'}
                onClick={() => act('panel')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="AI Settings">
          <LabeledList>
            <LabeledList.Item
              label="AI Connection Port"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_AISYNC}
                  tooltipPosition="left"
                />
              }
            >
              <Button
                icon={aisync ? 'unlock' : 'lock'}
                content={aisync ? 'Open' : 'Closed'}
                onClick={() => act('aisync')}
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="Master AI"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_AI}
                  tooltipPosition="left"
                />
              }
            >
              <Button
                icon={!aisync ? 'times' : master ? 'edit' : 'sync'}
                content={!aisync ? 'None' : master || 'Automatic'}
                color={master ? 'default' : 'good'}
                disabled={!aisync}
                onClick={() => act('set_ai')}
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="LawSync Port"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_LAWSYNC}
                  tooltipPosition="top-left"
                />
              }
            >
              <Button
                icon={!aisync ? 'lock' : lawsync ? 'unlock' : 'lock'}
                content={!aisync ? 'Closed' : lawsync ? 'Open' : 'Closed'}
                disabled={!aisync}
                onClick={() => act('lawsync')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
