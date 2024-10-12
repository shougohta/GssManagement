export interface gssRecord {
  id: number;
  student_name: string;
  gender: string;
  class_level: string;
  home_state: string;
  major: string;
  extracurricular_activity: string;
}

export type gssData = gssRecord[];
